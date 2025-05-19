from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.shortcuts import redirect
from django.http import HttpResponse

def healthcheck(request):
    return HttpResponse("OK")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('utilisateurs/', include('utilisateurs.urls')),
    path('stats/', include('stats.urls')),
    path('', include('languages.urls')),
    path('tools/', include('tools.urls')),
    path('health/', healthcheck, name='healthcheck'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)