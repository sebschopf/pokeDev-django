from django.db import models
from django.urls import reverse

class Languages(models.Model):
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True, null=True)
    short_description = models.TextField(blank=True, null=True)
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    logo_svg = models.TextField(blank=True, null=True)  # SVG logo
    slug = models.CharField(max_length=255, unique=True, db_index=True)
    type = models.CharField(max_length=50, blank=True, null=True, db_index=True)
    used_for = models.TextField(blank=True, null=True)
    usage_rate = models.FloatField(blank=True, null=True, db_index=True)
    year_created = models.IntegerField(blank=True, null=True, db_index=True)
    creator = models.CharField(max_length=255, blank=True, null=True)
    is_open_source = models.BooleanField(default=True, db_index=True)
    default_accessibility_level = models.ForeignKey(
        'AccessibilityLevels', models.DO_NOTHING, blank=True, null=True,
        related_name='default_for_languages', db_index=True
    )
    accessibility_score = models.FloatField(blank=True, null=True, db_index=True)
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

    @property
    def tools(self):
        """
        Retourne tous les outils associés à ce langage.
        """
        from tools.models import Tool
        return Tool.objects.filter(languages=self).select_related('technology_category').order_by('name')

    def get_tools_by_category(self, category_type):
        """
        Retourne les outils associés à ce langage, filtrés par type de catégorie technologique.
        """
        from tools.models import Tool
        return Tool.objects.filter(
            languages=self,
            technology_category__type__iexact=category_type
        ).order_by('name')

    @property
    def frameworks(self):
        return self.get_tools_by_category('Framework')

    @property
    def libraries(self):
        return self.get_tools_by_category('Bibliothèque')

    @property
    def engines(self):
        return self.get_tools_by_category('Moteur')

    @property
    def dev_tools(self):
        return self.get_tools_by_category('Outil')

    @property
    def accessibility_levels(self):
        """
        Récupère tous les niveaux d'accessibilité associés à ce langage.
        """
        from .accessibility import LanguageAccessibilityLevels
        return LanguageAccessibilityLevels.objects.filter(
            language=self
        ).select_related('accessibility_level')

    @property
    def accessibility_evaluations(self):
        """
        Récupère toutes les évaluations d'accessibilité pour ce langage.
        """
        from .accessibility import LanguageAccessibilityEvaluations
        return LanguageAccessibilityEvaluations.objects.filter(
            language=self
        ).select_related('criteria')

    def get_accessibility_level(self, level_number):
        """
        Récupère un niveau d'accessibilité spécifique pour ce langage.
        """
        from .accessibility import LanguageAccessibilityLevels
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
        Récupère toutes les caractéristiques de ce langage.
        """
        from .features import LanguageFeature
        return LanguageFeature.objects.filter(
            language=self
        ).select_related('feature').order_by('feature__display_order')

    def get_feature_value(self, feature_slug):
        """
        Récupère la valeur d'une caractéristique spécifique pour ce langage.
        """
        from .features import LanguageFeature, LanguageFeatures
        try:
            feature = LanguageFeatures.objects.get(slug=feature_slug)
            feature_value = LanguageFeature.objects.get(
                language=self,
                feature=feature
            )
            return feature_value.value
        except (LanguageFeatures.DoesNotExist, LanguageFeature.DoesNotExist):
            return None