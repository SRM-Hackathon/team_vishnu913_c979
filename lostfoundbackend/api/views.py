from django.contrib.auth.models import User
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.core.exceptions import SuspiciousOperation
from rest_framework.authtoken.models import Token
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from .models import *
from django.shortcuts import get_object_or_404
from django.core.files.base import ContentFile
import uuid
import base64
from django.contrib.auth import login
import pytz
import os
import threading
import face_recognition
from django.http import HttpResponse
from . import align_faces
from twilio.rest import Client

#! Functions


def cam_testing(founder_cam):
    # ! Testing the images obtained from camera with our images
    media_path = os.path.join(os.getcwd(), "media")
    target_img_path = os.path.join(media_path, str(founder_cam.img))
    target_img = face_recognition.load_image_file(target_img_path)
    print(target_img)
    faces = face_recognition.face_encodings(target_img)
    if len(faces) == 0:
        print("Not Found")
        return
    else:
        target_img_enc = faces[0]
    all_objs = Loser.objects.filter(location=founder_cam.location)
    for img_obj in all_objs:
        if img_obj.record_set.all().count() == 0:
            temp_img = face_recognition.load_image_file(img_obj.img)
            temp_img_enc = face_recognition.face_encodings(temp_img)[0]
            results = face_recognition.compare_faces(
                [target_img_enc], temp_img_enc)
            if results[0] == True:
                print("Found a match ")

                #! To Do
                #! Sending Message and push notifications
                #send_msg(img_obj.founder)
                record = Record()
                record.loser = img_obj
                record.camera = True
                record.founder=founder_cam
                record.save()
            else:
                print("Not Found")


def create_message(msg):
    # ! Message for the Whatsapp Bot
    response = MessagingResponse()
    response.message(msg)
    return str(response)


images_path = os.path.join(os.getcwd(), "media")


def send_msg(founder, loser):
    # ! Sending msg to the respective founders and loser
    account_sid = '#'
    auth_token = '#'
    client = Client(account_sid, auth_token)

    message = client.messages.create(
        body=f'Your child is found by {founder.user.username} and number is {founder.user.profile.phone_no}',
        from_='+1(205)448-6204',
        to=f'+91{loser.user.profile.phone_no}'
    )
    message2 = client.messages.create(
        body=f'The child you posted is lost by {loser.user.username} and number is {loser.user.profile.phone_no}',
        from_='+1(205)448-6204',
        to=f'+91{founder.user.profile.phone_no}'
    )

    print(message.sid)


def losttesting(obj):
    #!Searching for the lost child
    media_path = os.path.join(os.getcwd(), "media")
    target_img_path = os.path.join(media_path, str(obj.img))
    target_img = face_recognition.load_image_file(target_img_path)
    print(target_img)
    faces = face_recognition.face_encodings(target_img)
    if len(faces) == 0:
        print("!!Not Found")
        return
    else:
        target_img_enc = faces[0]
    all_objs = Founder.objects.filter(location=obj.location)
    if len(all_objs):

        for img_obj in all_objs:
            temp_img = face_recognition.load_image_file(img_obj.img)
            temp_img_enc = face_recognition.face_encodings(temp_img)[0]
            results = face_recognition.compare_faces(
                [target_img_enc], temp_img_enc)
            if results[0] == True:
                # ! Creating Records
                print("Found a match ")
                record = Record()

                record.loser = obj
                record.founder = img_obj
                record.save()
                send_msg(record.founder, record.loser)

            else:
                print("Not Found")


def foundtesting(obj):
    #! Searching for the found child
    media_path = os.path.join(os.getcwd(), "media")
    target_img_path = os.path.join(media_path, str(obj.img))
    target_img = face_recognition.load_image_file(target_img_path)
    print(target_img)
    target_img_enc = face_recognition.face_encodings(target_img)[0]
    all_objs = Loser.objects.filter(location=obj.location)
    if len(all_objs):

        for img_obj in all_objs:
            temp_img = face_recognition.load_image_file(img_obj.img)
            temp_img_enc = face_recognition.face_encodings(temp_img)[0]
            results = face_recognition.compare_faces(
                [target_img_enc], temp_img_enc)
            if results[0] == True:
                print("Found a match ")
                record = Record()

                record.founder = obj
                record.loser = img_obj
                record.save()
                #! To Do
                #! Sending Message and push notifications
                send_msg(record.founder, record.loser)

            else:
                print("Not Found")


def whatsapplost(obj, lost):
    #! Checking in Whatsapp
    if lost:
        media_path = os.path.join(os.getcwd(), "media")
        target_img_path = os.path.join(media_path, str(obj.img))
        target_img = face_recognition.load_image_file(target_img_path)
        print(target_img)
        target_img_enc = face_recognition.face_encodings(target_img)[0]
        all_objs = Founder.objects.filter(location=obj.location)
        if len(all_objs):

            for img_obj in all_objs:
                temp_img = face_recognition.load_image_file(img_obj.img)
                temp_img_enc = face_recognition.face_encodings(temp_img)[0]
                results = face_recognition.compare_faces(
                    [target_img_enc], temp_img_enc)
                if results[0] == True:
                    print("Found a match ")
                else:
                    pass


class LoginView(APIView):
    #! LoginView
    permission_classes = (AllowAny,)
    def post(self, request):

        user = User.objects.get(email=request.POST.get('email'))
        if user is None:
            raise SuspiciousOperation

        user = authenticate(request=request, username=user.username.strip(),
                            password=request.POST.get('password').strip())
        print(user)
        if not user:
            raise SuspiciousOperation
        #login(request, user)
        token, dummy = Token.objects.get_or_create(user=user)
        profile = Profile.objects.get(user=user)
        profile.device_id = request.POST.get('device_id')
        profile.save()
        return Response({"token": token.key})


class RegisterView(APIView):
    # ! Register View
    permission_classes = (AllowAny,)

    def post(self, request):

        if User.objects.filter(username=request.POST.get('username')).exists() or User.objects.filter(email=request.POST.get('email')).exists():
            raise SuspiciousOperation
        else:
            print("Entering view")
            user = User()
            user.email = request.POST.get('email')
            user.username = request.POST.get('username')
            user.set_password(request.POST.get('password'))
            user.save()
            profile = Profile()
            profile.user = user
            profile.phone_no = request.POST.get('phone_number')
            if request.POST.get("device_id") != None:
                profile.device_id = request.POST.get("device_id")
            profile.save()
            return Response({'registered': True})


class FoundPostView(APIView):
    # ! Posting a found child
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def post(self, request):

        founder = Founder()
        founder.user = request.user
        founder.latitude = request.POST.get('latitude')
        founder.longitude = request.POST.get('longitude')
        data = request.POST.get('image')

        name = str(uuid.uuid4())

        data = ContentFile(base64.b64decode(data), name=f"{name}.jpg")
        founder.img = data
        founder.name = request.POST.get('name')
        founder.description = request.POST.get('description')
        founder.location = request.POST.get('location')
        founder.marker_id = request.POST.get('marker_id')
        founder.date_found = request.POST.get('date')
        founder.save()
        align_faces.align_face(os.path.join(images_path, str(founder.img)))
        #! Code to start testing the match
        thread = threading.Thread(target=foundtesting, args=(founder,))
        thread.start()

        return Response()


class LostPostView(APIView):
    #  ! Posting a lost child
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def post(self, request):
        print(request.POST)
        loser = Loser()
        loser.user = request.user
        loser.latitude = request.POST.get('latitude')
        loser.longitude = request.POST.get('longitude')
        loser.marker_id = request.POST.get('marker_id')
        data = request.POST.get('image')

        name = str(uuid.uuid4())

        data = ContentFile(base64.b64decode(data), name=f"{name}.jpg")
        loser.img = data
        #!Align Faces
        loser.name = request.POST.get('name')
        loser.description = request.POST.get('description')
        loser.location = request.POST.get('location')
        loser.date_found = request.POST.get('date')
        loser.save()
        align_faces.align_face(os.path.join(images_path, str(loser.img)))

        #! Code to start testing the match
        thread = threading.Thread(target=losttesting, args=(loser,))
        thread.start()
        return Response()


def check_record(founder):
    pass


class LostView(APIView):
    # ! Fees in Website
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def get(self, request):
        return Response([
            {
                'name': loser.user.username,
                'email': loser.user.email,
                'description': loser.description,
                'img': loser.img.url,
                'location': loser.location,
                'latitude': loser.latitude,
                'longitude': loser.longitude,
                'date_lost': loser.date_lost,
                'phone_no': loser.user.profile.phone_no

            }
            for loser in Loser.objects.all()])


class FoundView(APIView):
    # !Feed in website
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def get(self, request):
        return Response([
            {
                'name': founder.user.username,
                'email': founder.user.email,
                'phone_no': founder.user.profile.phone_no,
                'description': founder.description,
                'img': founder.img.url,
                'location': founder.location,
                'latitude': founder.latitude,
                'longitude': founder.longitude,
                'date_found': founder.date_found,
                'phone_no': founder.user.profile.phone_no

            }
            for founder in Founder.objects.all()])


class MyFoundView(APIView):
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def get(self, request):

        return Response(
            [{
                'name': founder.user.username,
                'email': founder.user.email,
                'phone_no': founder.user.profile.phone_no,
                'description': founder.description,
                'img': founder.img.url,
                'location': founder.location,
                'date_lost': founder.date_found,
                'latitude': founder.latitude,
                'longitude': founder.longitude,

            } for founder in Founder.objects.filter(user=request.user)]
        )


class MyLostView(APIView):
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def get(self, request):

        return Response([{
            'name': loser.user.username,
            'email': loser.user.email,
            'phone_no': loser.user.profile.phone_no,
            'description': loser.description,
            'img': loser.img.url,
            'location': loser.location,
            'date_lost': loser.date_lost,
            'latitude': loser.latitude,
            'longitude': loser.longitude,

        } for loser in Loser.objects.filter(user=request.user)])


class BotView(APIView):
    # !Handler fot Whatsapp Bot
    permission_classes = (AllowAny,)

    def get(self, request):
        print(request.POST)
        num = request.POST.get('From').split(':')[1]
        if 'Body' in request.POST:
            if request.POST.get("Body") == "Hi":

                person, created = TwilioModel.objects.get_or_create(
                    whatsapp_num=num)
                print(person.num)
                return HttpResponse(create_message("Hey"))
            elif 'lost'.lower() in request.POST.get("Body").lower():
                person = get_object_or_404(TwilioModel, whatsapp_num=num)
                person.lost = True
                person.save()
                return HttpResponse(create_message("Cool !! Where did you lost your child give his name in the format Name:"))
            elif 'found'.lower() in request.POST.get("Body").lower():
                person = get_object_or_404(TwilioModel, whatsapp_num=num)
                person.lost = False
                person.save()

                return HttpResponse(create_message("Cool !! Where did you lost your child give his name in the format Name:"))
            elif "Name:" in request.POST.get('Body'):
                person = get_object_or_404(TwilioModel, whatsapp_num=num)
                data = request.POST.get('Body').replace('\n', ':').split(':')
                person.name = data[1]
                person.location = data[3]
                person.save()
                print(person.location)
                return HttpResponse(create_message(f"The thing you entered is {request.POST.get('Body')} send the Image of the child"))
            elif 'MediaUrl0' in request.POST:
                person = get_object_or_404(TwilioModel, whatsapp_num=num)
                print(request.POST.get('MediaUrl0'))
                resp = requests.get(request.POST.get('MediaUrl0'), timeout=25)
                fp = BytesIO()
                fp.write(resp.content)
                person.image.save(f'{uuid.uuid4()}.jpeg', files.File(fp))
                align_faces.align_face(os.path.join(
                    images_path, str(person.image)))
                if fp is not None and person.lost:
                    pass
                elif fp is not None and not person.lost:
                    pass
                else:
                    pass

                return HttpResponse(create_message("Ohoo!! It works"))
            else:
                return HttpResponse(create_message("You already said HI"))

        return Response()


class CamView(APIView):
     # ! Processing Live Feed from Camera
    permission_classes = (AllowAny,)

    def post(self, request):
        print(request.FILES.get('file'))
        founder_cam = Founder.objects.get(pk=1)
        founder_cam.img = request.FILES.get("file")
        founder_cam.save()
        cam_testing(founder_cam)
        return Response()




class FoundHomeView(APIView):
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def get(self, request):
        records = []
        for image in request.user.founder_set.all():
            for record in image.record_set.all():
                temp = {
                    'loser_name': record.loser.user.username,
                    'loser_num': record.loser.user.profile.phone_no,

                    'loser_location': record.loser.location,
                    'loser_img': record.loser.img.url,
                    'founder_img': record.founder.img.url,
                    'latitude': record.loser.latitude,
                    'longitude': record.loser.longitude,
                    'description': record.loser.description,
                    'camera': record.camera
                }
                records.append(temp)
        return Response(records)


class LostHomeView(APIView):
    permission_classes = (IsAuthenticated,)
    authentication_classes = (TokenAuthentication,)

    def get(self, request):
        records = []
        for image in request.user.loser_set.all():
            for record in image.record_set.all():
                temp = {
                    'founder_name': record.founder.user.username,
                    'founder_num': record.founder.user.profile.phone_no,

                    'founder_location': record.founder.location,
                    'loser_img': record.loser.img.url,
                    'founder_img': record.founder.img.url,
                    'latitude': record.founder.latitude,
                    'longitude': record.founder.longitude,
                    'description': record.founder.description,
                    'camera': record.camera,
                    
                    
                }
                records.append(temp)
        return Response(records)
