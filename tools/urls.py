from django.urls import path
from . import views

app_name = 'tools'

urlpatterns = [
    path('test/', views.test_view, name='test'),
    path('<slug:slug>/', views.tool_detail, name='detail'),
]