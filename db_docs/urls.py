# db_docs/urls.py
from django.urls import path
from . import views

app_name = 'db_docs'

urlpatterns = [
    path('', views.index, name='index'),
    path('chapter/<slug:slug>/', views.ChapterDetailView.as_view(), name='chapter_detail'),
]