# languages/urls.py
from django.urls import path
from . import views

app_name = 'languages'

urlpatterns = [
    path('', views.list, name='list'),
    path('<slug:slug>/', views.LanguageDetailView.as_view(), name='detail'), 
    path('<slug:language_slug>/<slug:framework_slug>/', views.framework_detail, name='framework_detail'),
    # path('<slug:slug>/propose-correction/', views.propose_correction, name='propose_correction'),
]