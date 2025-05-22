# languages/models/language.py
from django.db import models
from django.contrib.postgres.fields import ArrayField
from django.urls import reverse

class Languages(models.Model):
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True, null=True)
    short_description = models.TextField(blank=True, null=True)
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    logo_svg = models.TextField(blank=True, null=True) # SVG logo
    slug = models.CharField(max_length=255, unique=True, db_index=True)  # Expliciter l'index
    type = models.CharField(max_length=50, blank=True, null=True, db_index=True)  # Ajout d'index
    used_for = models.TextField(blank=True, null=True)
    usage_rate = models.FloatField(blank=True, null=True, db_index=True)  # Ajout d'index
    year_created = models.IntegerField(blank=True, null=True, db_index=True)  # Ajout d'index
    creator = models.CharField(max_length=255, blank=True, null=True)
    popular_frameworks = ArrayField(models.CharField(max_length=255), blank=True, null=True)
    strengths = ArrayField(models.CharField(max_length=255), blank=True, null=True)
    is_open_source = models.BooleanField(default=True, db_index=True)  # Ajout d'index
    default_accessibility_level = models.ForeignKey('AccessibilityLevels', models.DO_NOTHING, blank=True, null=True, related_name='default_for_languages', db_index=True)  # Expliciter l'index
    accessibility_score = models.FloatField(blank=True, null=True, db_index=True)  # Ajout d'index
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'languages'
        indexes = [
            models.Index(fields=['slug']),
            models.Index(fields=['type']),
            models.Index(fields=['year_created']),
            models.Index(fields=['usage_rate']),
            models.Index(fields=['is_open_source']),
            models.Index(fields=['accessibility_score']),
        ]

    def __str__(self):
        return self.name
    
    def get_absolute_url(self):
        """
        Retourne l'URL de la page de détail de ce langage
        """
        return reverse('languages:detail', kwargs={'slug': self.slug})

    def get_libraries_by_type(self, type_name):
        """
        Récupère les bibliothèques associées à ce langage, filtrées par type
        Optimisé avec select_related pour réduire les requêtes
        """
        from .library import Libraries, LibraryLanguages
    
        library_ids = LibraryLanguages.objects.filter(
            language_id=self.id
        ).values_list('library_id', flat=True)
    
        return Libraries.objects.filter(
            id__in=library_ids,
            technology_type=type_name
        ).order_by('name')

    @property
    def frameworks(self):
        return self.get_libraries_by_type('framework')
    
    @property
    def libraries(self):
        return self.get_libraries_by_type('library')
    
    @property
    def engines(self):
        return self.get_libraries_by_type('engine')
    
    @property
    def dev_tools(self):
        return self.get_libraries_by_type('tool')
    
    @property
    def accessibility_levels(self):
        """
        Récupère tous les niveaux d'accessibilité associés à ce langage
        Optimisé avec select_related pour réduire les requêtes
        """
        from .accessibility import LanguageAccessibilityLevels, AccessibilityLevels
        return LanguageAccessibilityLevels.objects.filter(
            language=self
        ).select_related('accessibility_level')
    
    @property
    def accessibility_evaluations(self):
        """
        Récupère toutes les évaluations d'accessibilité pour ce langage
        Optimisé avec select_related pour réduire les requêtes
        """
        from .accessibility import LanguageAccessibilityEvaluations, AccessibilityCriteria
        return LanguageAccessibilityEvaluations.objects.filter(
            language=self
        ).select_related('criteria')
    
    def get_accessibility_level(self, level_number):
        """
        Récupère un niveau d'accessibilité spécifique pour ce langage
        """
        from .accessibility import LanguageAccessibilityLevels, AccessibilityLevels
        try:
            return LanguageAccessibilityLevels.objects.get(
                language=self,
                accessibility_level__level_number=level_number
            )
        except LanguageAccessibilityLevels.DoesNotExist:
            return None
        
    @property
    def features(self):
        """
        Récupère toutes les caractéristiques de ce langage
        Optimisé avec select_related pour réduire les requêtes
        """
        from .features import LanguageFeatureValues
        return LanguageFeatureValues.objects.filter(
            language=self
        ).select_related('feature').order_by('feature__display_order')

    def get_feature_value(self, feature_slug):
        """
        Récupère la valeur d'une caractéristique spécifique pour ce langage
        """
        from .features import LanguageFeatureValues, LanguageFeatures
        try:
            feature = LanguageFeatures.objects.get(slug=feature_slug)
            feature_value = LanguageFeatureValues.objects.get(
                language=self,
                feature=feature
            )
            return feature_value.value
        except (LanguageFeatures.DoesNotExist, LanguageFeatureValues.DoesNotExist):
            return None

    