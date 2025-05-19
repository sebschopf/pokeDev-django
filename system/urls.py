from django.urls import path
from .views import healthcheck_view

urlpatterns = [
    path('health/', healthcheck_view, name='healthcheck'),
]