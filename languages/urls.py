from django.urls import path, include
from .views import list, LanguageDetailView, framework_detail
from .views.corrections_views import propose_correction, correction_list, correction_detail
from .views.search_views import advanced_search
from .views import docs_views

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

# URLs principales
urlpatterns = [
    # URL pour la documentation
    path('accessibility-methodology/', docs_views.accessibility_methodology, name='accessibility_methodology'),
    
    # URLs pour les langages
    path('', include(language_patterns)),
    
    # URLs pour les corrections
    path('manage/corrections/', include(correction_patterns)),
    

    # URL pour la recherche avancée
    path('search/', advanced_search, name='advanced_search'),
]
