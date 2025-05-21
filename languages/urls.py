# languages/urls.py
from django.urls import path, include
from . import views
from . import views_corrections

app_name = 'languages'

# URLs pour les langages
language_patterns = [
    path('', views.list, name='list'),
    path('<slug:slug>/', views.LanguageDetailView.as_view(), name='detail'),
    path('<slug:slug>/propose-correction/', views_corrections.propose_correction, name='propose_correction'),
    path('<slug:language_slug>/<slug:framework_slug>/', views.framework_detail, name='framework_detail'),
]

# URLs pour les corrections
correction_patterns = [
    path('', views_corrections.correction_list, name='correction_list'),
    path('<int:correction_id>/', views_corrections.correction_detail, name='correction_detail'),
]

# URLs principales
urlpatterns = [
    # URLs pour les langages
    path('', include(language_patterns)),
    
    # URLs pour les corrections (déplacées de admin/corrections/ à manage/corrections/)
    path('manage/corrections/', include(correction_patterns)),
]