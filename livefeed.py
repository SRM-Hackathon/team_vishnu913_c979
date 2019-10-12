# import the necessary packages
from picamera.array import PiRGBArray
from picamera import PiCamera
import time
import cv2
import requests
import threading
import numpy as np

def send_to_server(image):
    image = cv2.resize(image,(300,300))
    encoded = cv2.imencode(".jpg",image)[1]
    file = {"file":("image.jpg",encoded.tostring(),'image/jpeg',{'Expires':'0'})}
    data = {"loc":"Gandhipuram"}
    requests.post("http://87046cfe.ngrok.io/cam/",files=file,data=data)

def adjust_gamma(image,gamma):
    invgamma = 1.0/gamma
    table = np.array([((i/255.0)**invgamma)*255 for i in np.arange(0,256)]).astype("uint8")
    return cv2.LUT(image,table)
    
# initialize the camera and grab a reference to the raw camera capture
camera = PiCamera()
camera.resolution = (640, 480)
camera.framerate = 80
rawCapture = PiRGBArray(camera, size=(640, 480))
faceCascade = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_alt2.xml")

 
# allow the camera to warmup
time.sleep(0.1)
 
# capture frames from the camera
for frame in camera.capture_continuous(rawCapture, format="bgr", use_video_port=True):
    # grab the raw NumPy array representing the image, then initialize the timestamp
    # and occupied/unoccupied text
    image = frame.array
    image = adjust_gamma(image,1.5)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    faces = faceCascade.detectMultiScale(
    gray,
    scaleFactor=1.3,
    minNeighbors=3,
    minSize=(30, 30)
    )


    for (x, y, w, h) in faces:
        roi_color = image[y:y + h, x:x + w].copy()
        threading.Thread(target=send_to_server,args=(),kwargs={"image":roi_color}).start()
    
    for (x,y,w,h) in faces:
        cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)
     
    # show the frame
    cv2.imshow("Frame", image)
    key = cv2.waitKey(1) & 0xFF
 
    # clear the stream in preparation for the next frame
    rawCapture.truncate(0)
 
    # if the `q` key was pressed, break from the loop
    if key == ord("q"):
        break
