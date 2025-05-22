from django.urls import path, include
from .views import list, LanguageDetailView, framework_detail
from .views.corrections_views import propose_correction, correction_list, correction_detail
from .views.api_views import get_field_value
from .views.search_views import advanced_search
from .views import corrections_views

app_name = 'languages'

# URLs pour les langages
language_patterns = [
    path('', list, name='list'),
    path('<slug:slug>/', LanguageDetailView.as_view(), name='detail'),
    path('<slug:slug>/propose-correction/', propose_correction, name='propose_correction'),
    path('<slug:language_slug>/<slug:framework_slug>/', framework_detail, name='framework_detail'),
]

# URLs pour les corrections
correction_patterns = [
    path('', correction_list, name='correction_list'),
    path('<int:correction_id>/', correction_detail, name='correction_detail'),
]

# URLs pour l'API
api_patterns = [
    path('field-value/<slug:slug>/<str:field_name>/', get_field_value, name='get_field_value'),
]

# URLs principales
urlpatterns = [
    # URLs pour les langages
    path('', include(language_patterns)),
    
    # URLs pour les corrections (déplacées de admin/corrections/ à manage/corrections/)
    path('manage/corrections/', include(correction_patterns)),
    
    # URLs pour l'API
    path('api/field-value/<slug:slug>/<str:field_name>/', corrections_views.get_field_value, name='get_field_value'),

    # URL pour la recherche avancée (si nécessaire)
    path('search/', advanced_search, name='advanced_search'),  # Ajouter cette ligne si nécessaire
]