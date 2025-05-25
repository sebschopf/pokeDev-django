from django.urls import path
from . import views

app_name = 'api'

urlpatterns = [
    # ===== MENU MOBILE =====
    path('mobile-menu/', views.mobile_menu_partial, name='mobile_menu_partial'),
    path('mobile-menu-json/', views.mobile_menu_partial_json, name='mobile_menu_partial_json'),
    
    # ===== LANGUAGES =====
    path('languages/<slug:slug>/<str:field_name>/', views.get_field_value, name='get_field_value'),
    
    # ===== SEARCH =====
    path('search/suggestions/', views.search_suggestions, name='search_suggestions'),
    
    # ===== MONITORING =====
    path('health/', views.health_check, name='health_check'),
]
