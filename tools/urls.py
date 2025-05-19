from django.urls import path
from . import views

app_name = 'tools'  # Définit le namespace 'tools'

urlpatterns = [
    path('<slug:slug>/', views.tool_detail, name='detail'),
]
