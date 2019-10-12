from django.urls import path
from . import views
urlpatterns = [
    path('login/',views.LoginView.as_view()),
    path('register/',views.RegisterView.as_view()),
    path('found/',views.FoundPostView.as_view()),
    path('lost/',views.LostPostView.as_view()),
    path('cam/',views.CamView.as_view()),
    path('myfound/',views.MyFoundView.as_view()),
    path('mylost/',views.MyLostView.as_view()),
    path('dummy/',views.Dummy.as_view()),
    #path('lostrecord/',views.LostRecordView.as_view())
    
]
