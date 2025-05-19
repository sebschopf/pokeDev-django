from django.shortcuts import render, get_object_or_404, redirect
from django.views.generic import ListView, DetailView
from django.contrib.auth.decorators import login_required
from django.db.models import Q
from .models import Languages, Libraries, TechnologyCategories, TechnologySubtypes, UsageCategories
from .models.library import LibraryLanguages

# Vue basée sur une fonction pour la liste des langages
def list(request):
    languages = Languages.objects.all()
    return render(request, 'languages/list.html', {'languages': languages})

# Vue pour afficher les détails d'un framework spécifique pour un langage
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

class LanguageListView(ListView):
    model = Languages
    template_name = 'languages/list.html'
    context_object_name = 'languages'

class LanguageDetailView(DetailView):
    model = Languages
    template_name = 'languages/detail.html'
    context_object_name = 'language'
    slug_field = 'slug'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        language = self.get_object()
        
        # Préparer les données "used_for" si elles existent
        if language.used_for:
            try:
                context['used_for_list'] = [use.strip() for use in language.used_for.split(',')]
            except:
                # Si split échoue, utilisez la valeur telle quelle
                context['used_for_list'] = [language.used_for]
        
        # Récupérer les catégories d'usage
        if hasattr(language, 'languageusage_set'):
            usage_categories = UsageCategories.objects.filter(
                languageusage__language=language
            )
            context['usage_categories'] = usage_categories
        
        # Ajouter les frameworks populaires s'ils ne sont pas déjà dans la liste des frameworks
        if language.popular_frameworks:
            context['popular_frameworks'] = language.popular_frameworks
        
        return context
