from django.urls import path
from . import views

app_name = 'utilisateurs'

urlpatterns = [
    path('profile/', views.profile, name='profile'),
]