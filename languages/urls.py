# languages/urls.py
from django.urls import path
from . import views

app_name = 'languages'

urlpatterns = [
    path('', views.language_list, name='language_list'),
    path('<slug:slug>/', views.language_detail, name='language_detail'),
    path('<slug:language_slug>/<slug:framework_slug>/', views.framework_detail, name='framework_detail'),
]