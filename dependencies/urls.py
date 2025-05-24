from django.urls import path
from . import views

app_name = 'dependencies'

urlpatterns = [
    path('', views.tribute_view, name='tribute'),
]
