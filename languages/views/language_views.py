from django.shortcuts import render, get_object_or_404
from django.views.generic import ListView, DetailView
from django.db.models import Q, Prefetch

from ..models import Languages, UsageCategories
from ..models.library import LibraryLanguages
from ..models.usage import LanguageUsage
from ..models.accessibility import AccessibilityLevels, LanguageAccessibilityLevels, LanguageAccessibilityEvaluations
from ..models.features import LanguageFeatures
from tools.models import Tool, TechnologyCategory

# Vue basée sur une fonction pour la liste des langages
def list(request):
    languages = Languages.objects.all()
    return render(request, 'languages/list.html', {'languages': languages})

class LanguageListView(ListView):
    model = Languages
    template_name = 'languages/list.html'
    context_object_name = 'languages'

    def get_queryset(self):
        # Préchargement de toutes les relations nécessaires
        return Languages.objects.select_related(
            'default_accessibility_level'
        ).prefetch_related(
            'languageaccessibilitylevels_set__accessibility_level',
            'languagefeatures_set__feature',
            Prefetch('languageusage_set', queryset=LanguageUsage.objects.select_related('category'))
        )

class LanguageDetailView(DetailView):
    model = Languages
    template_name = 'languages/detail.html'
    context_object_name = 'language'
    slug_field = 'slug'

    def get_queryset(self):
        # Préchargement optimisé de toutes les relations
        return Languages.objects.select_related(
            'default_accessibility_level'
        ).prefetch_related(
            Prefetch(
                'languageaccessibilitylevels_set',
                queryset=LanguageAccessibilityLevels.objects.select_related('accessibility_level').order_by('accessibility_level__level_order'),
                to_attr='prefetched_accessibility_levels'
            ),
            Prefetch(
                'languagefeatures_set',
                queryset=LanguageFeatures.objects.select_related('feature').order_by('feature__display_order'),
                to_attr='prefetched_features'
            ),
            Prefetch(
                'librarylanguages_set',
                queryset=LibraryLanguages.objects.select_related('library'),
                to_attr='prefetched_library_languages'
            )
        )

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
        
        # Utiliser les données préchargées pour l'accessibilité
        try:
            # Récupérer le niveau d'accessibilité par défaut
            if language.default_accessibility_level_id:
                context['default_accessibility_level'] = language.default_accessibility_level
            
            # Utiliser les données préchargées pour les niveaux d'accessibilité
            if hasattr(language, 'prefetched_accessibility_levels'):
                accessibility_levels = language.prefetched_accessibility_levels
                context['accessibility_levels'] = accessibility_levels
                
                # Récupérer les évaluations d'accessibilité pour chaque niveau
                for level in accessibility_levels:
                    level.evaluations = LanguageAccessibilityEvaluations.objects.filter(
                        language_accessibility_level_id=level.id
                    ).select_related('criteria').order_by('-score')
            else:
                # Fallback au cas où les données préchargées ne sont pas disponibles
                accessibility_levels = LanguageAccessibilityLevels.objects.filter(
                    language=language
                ).select_related('accessibility_level').order_by('accessibility_level__level_order')
                context['accessibility_levels'] = accessibility_levels
                
                for level in accessibility_levels:
                    level.evaluations = LanguageAccessibilityEvaluations.objects.filter(
                        language_accessibility_level_id=level.id
                    ).select_related('criteria').order_by('-score')
        except Exception as e:
            # En cas d'erreur, logger l'erreur mais ne pas planter la page
            print(f"Erreur lors de la récupération des données d'accessibilité: {e}")
        
        # Utiliser les données préchargées pour les caractéristiques
        try:
            if hasattr(language, 'prefetched_features'):
                features = language.prefetched_features
            else:
                # Fallback au cas où les données préchargées ne sont pas disponibles
                features = LanguageFeatures.objects.filter(
                    language=language
                ).select_related('feature').order_by('feature__display_order')
            
            # Organiser les caractéristiques par type
            features_by_type = {}
            for feature_value in features:
                feature_type = feature_value.feature.feature_type
                if feature_type not in features_by_type:
                    features_by_type[feature_type] = []
                features_by_type[feature_type].append(feature_value)
            
            context['features_by_type'] = features_by_type
        except Exception as e:
            # En cas d'erreur, logger l'erreur mais ne pas planter la page
            print(f"Erreur lors de la récupération des caractéristiques: {e}")
        
                # Utiliser les données préchargées pour les outils associés
        try:
            # On récupère tous les outils liés à ce langage, avec leur catégorie technologique
            tools = Tool.objects.filter(languages=language).select_related('technology_category').order_by('technology_category__type', 'name')
            # On groupe les outils par catégorie technologique
            tools_by_category = {}
            for tool in tools:
                cat = tool.technology_category
            if cat not in tools_by_category:
                tools_by_category[cat] = []
            tools_by_category[cat].append(tool)
            context['tools_by_category'] = tools_by_category.items()  # Pour itérer dans le template
        except Exception as e:
            print(f"Erreur lors de la récupération des outils associés: {e}")

        return context
