"""
Cette vue utilise une class-based view (CBV) pour la recherche d'outils.
Pourquoi CBV ? 
- Plus maintenable et évolutif pour des recherches complexes (filtres dynamiques, pagination, classement).
- Permet d'ajouter facilement des méthodes (ex : get_queryset, get_context_data).
- Recommandé pour les projets Django modernes avec beaucoup de logique métier.
"""

from django.views.generic import ListView
from django.db.models import Q
from tools.models import Tool, TechnologyCategory, TechnologySubtype, Languages

class ToolSearchView(ListView):
    model = Tool
    template_name = 'tools/search.html'
    context_object_name = 'tools'
    paginate_by = 20

    def get_queryset(self):
        queryset = Tool.objects.all().distinct()
        # Récupération des paramètres GET
        name = self.request.GET.get('name', '')
        category_id = self.request.GET.get('category')
        subtype_id = self.request.GET.get('subtype')
        language_id = self.request.GET.get('language')

        # Filtrage dynamique
        if name:
            queryset = queryset.filter(name__icontains=name)
        if category_id:
            queryset = queryset.filter(technology_category_id=category_id)
        if subtype_id:
            queryset = queryset.filter(technology_subtypes__id=subtype_id)
        if language_id:
            queryset = queryset.filter(languages__id=language_id)

        # Classement intelligent selon les filtres
        if category_id and language_id:
            queryset = queryset.order_by('technology_subtypes__name', 'name')
        elif category_id:
            queryset = queryset.order_by('languages__name', 'technology_subtypes__name', 'name')
        else:
            queryset = queryset.order_by('name')

        return queryset

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Pour les menus déroulants dynamiques
        context['categories'] = TechnologyCategory.objects.all()
        context['languages'] = Languages.objects.all()

        # Sous-catégories dynamiques selon le filtre
        category_id = self.request.GET.get('category')
        if category_id:
            context['subtypes'] = TechnologySubtype.objects.filter(category_id=category_id)
        else:
            context['subtypes'] = TechnologySubtype.objects.all()

        # Pour garder les valeurs sélectionnées dans le formulaire
        context['selected_name'] = self.request.GET.get('name', '')
        context['selected_category'] = category_id
        context['selected_subtype'] = self.request.GET.get('subtype')
        context['selected_language'] = self.request.GET.get('language')
        return context