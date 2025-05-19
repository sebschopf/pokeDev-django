from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.shortcuts import redirect
from django.http import HttpResponse

urlpatterns = [
    path('admin/', admin.site.urls),
    path('utilisateurs/', include('utilisateurs.urls')),
    path('stats/', include('stats.urls')),
    path('outils/', include('tools.urls')),
    path('', include('languages.urls')),
    path('', include('system.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)