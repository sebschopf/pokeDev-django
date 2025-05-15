# languages/urls.py
from django.urls import path
from . import views

app_name = 'languages'

urlpatterns = [
    path('', views.list, name='list'),
    path('<slug:slug>/', views.detail, name='detail'),
    path('<slug:language_slug>/<slug:framework_slug>/', views.detail, name='detail'),
]