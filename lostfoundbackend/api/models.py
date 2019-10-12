from django.db import models
from django.contrib.auth.models import User


class TwilioModel(models.Model):
    whatsapp_num = models.CharField(max_length=10)
    image = models.ImageField()
    name = models.TextField()
    location = models.TextField()
    lost = models.BooleanField(default=False)

class CameraModel(models.Model):
    image = models.ImageField()
    location = models.TextField()

class Profile(models.Model):
    user=models.OneToOneField(User,on_delete=models.CASCADE)
    phone_no=models.CharField(max_length=10)
    device_id=models.TextField(null=True,blank=True)

class Founder(models.Model):
    user=models.ForeignKey(User,on_delete=models.CASCADE)
    name=models.TextField()
    img=models.ImageField()
    latitude=models.CharField(max_length=100)
    longitude=models.CharField(max_length=100)
    description=models.TextField()
    location=models.TextField()
    date_found=models.TextField()
   

class Loser(models.Model):
    user=models.ForeignKey(User,on_delete=models.CASCADE)
    name=models.TextField()
    img=models.ImageField()
    latitude=models.CharField(max_length=100)
    longitude=models.CharField(max_length=100)
    location=models.TextField()
    description=models.TextField()
    date_lost=models.TextField()
   

class Record(models.Model):
      founder=models.ForeignKey(Founder,on_delete=models.CASCADE)
      loser=models.ForeignKey(Loser,on_delete=models.CASCADE)    
