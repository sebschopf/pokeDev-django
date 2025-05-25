from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.shortcuts import redirect
from django.http import HttpResponse

# Fonction de redirection vers la page de liste des langages
def redirect_to_languages(request):
    return redirect('languages:list')

# Enregistrer les modèles avec le site d'administration personnalisé
from languages.models import (
    Languages, Corrections, LanguageProposals, LanguagesFramework,
    Libraries, LibraryLanguages,
    TechnologyCategories, TechnologySubtypes,
    UsageCategories, LanguageUsage
)
from languages.admin import (
    LanguagesAdmin, CorrectionsAdmin
)

urlpatterns = [

    path('', redirect_to_languages, name='home'), # Redirection vers la page de liste des langages
    path('admin/', admin.site.urls),
    path('db-docs/', include('db_docs.urls')),
    path('utilisateurs/', include('utilisateurs.urls')),
    path('stats/', include('stats.urls')),
    path('outils/', include('tools.urls')),
    path('languages/', include('languages.urls')),
    path('', include('system.urls')),
    path('dependencies/', include('dependencies.urls')),
    path('api/', include('api.urls')),
    # SEO URLs - IMPORTANT: à la fin pour éviter les conflits
    path('sitemap.xml', include('seo.urls')),
    path('robots.txt', include('seo.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)