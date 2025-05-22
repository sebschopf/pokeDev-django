from django.shortcuts import render, get_object_or_404
from ..models import Languages, Libraries

def framework_detail(request, language_slug, framework_slug):
    language = get_object_or_404(Languages, slug=language_slug)
    # Adapter cette partie selon le modèle de données pour les frameworks
    # Par exemple,:
    # framework = get_object_or_404(Framework, slug=framework_slug, language=language)
    # Ou si les frameworks sont dans Libraries:
    framework = get_object_or_404(Libraries, slug=framework_slug, language=language)

    return render(request, 'languages/framework_detail.html', {
        'language': language,
        'framework': framework
    })