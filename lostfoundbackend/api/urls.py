from django.urls import path
from . import views
urlpatterns = [
    path('login/',views.LoginView.as_view()),
    path('register/',views.RegisterView.as_view()),
    path('found/',views.FoundPostView.as_view()),
    path('lost/',views.LostPostView.as_view()),
    path('cam/',views.CamView.as_view()),
    path('foundhome/',views.FoundHomeView.as_view()),
    path('losthome/',views.LostHomeView.as_view()),
    path('dummy/',views.Dummy.as_view()),
    path('genfound/',views.FoundView.as_view()),
    path('genlost/',views.LostView.as_view())     ,
    path('bot/',views.BotView.as_view())                                                                                                                                                  
    #path('lostrecord/',views.LostRecordView.as_view())
    
]
