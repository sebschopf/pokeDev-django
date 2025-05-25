from django.urls import path
from . import views

app_name = 'seo'

urlpatterns = [
    path('sitemap.xml', views.sitemap_xml, name='sitemap'),
    path('robots.txt', views.robots_txt, name='robots'),
]
