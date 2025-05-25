from django.db import models
from .language import Languages

class Features(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    slug = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    feature_type = models.CharField(max_length=50)
    is_boolean = models.BooleanField(default=False)
    has_multiple_values = models.BooleanField(default=False)
    possible_values = models.JSONField(blank=True, null=True)
    default_value = models.CharField(max_length=100, blank=True, null=True)
    importance_weight = models.IntegerField(default=0)
    display_order = models.IntegerField(default=0)
    icon_path = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'features'
        ordering = ['display_order', 'name']
        verbose_name = 'Caractéristique'
        verbose_name_plural = 'Caractéristiques'

    def __str__(self):
        return self.name

    @classmethod
    def get_by_type(cls):
        """
        Récupère les caractéristiques groupées par type
        """
        features = cls.objects.all().order_by('feature_type', 'display_order')
        features_by_type = {}
        for feature in features:
            if feature.feature_type not in features_by_type:
                features_by_type[feature.feature_type] = []
            features_by_type[feature.feature_type].append(feature)
        return features_by_type


class LanguageFeatures(models.Model):
    id = models.AutoField(primary_key=True)
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    feature = models.ForeignKey(Features, models.DO_NOTHING)
    value = models.CharField(max_length=255)
    # Champ value_details selon la structure DB réelle
    value_details = models.TextField(blank=True, null=True)
    is_primary = models.BooleanField(default=True)
    source_url = models.URLField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'language_features'
        verbose_name = 'Caractéristique de langage'
        verbose_name_plural = 'Caractéristiques de langage'

    def __str__(self):
        return f"{self.language.name} - {self.feature.name}: {self.value}"

    @classmethod
    def get_features_by_language_and_type(cls, language_id):
        """
        Récupère les caractéristiques d'un langage groupées par type
        """
        features = cls.objects.filter(
            language_id=language_id
        ).select_related('feature').order_by(
            'feature__feature_type', 
            'feature__display_order'
        )
        
        features_by_type = {}
        for language_feature in features:
            feature_type = language_feature.feature.feature_type
            if feature_type not in features_by_type:
                features_by_type[feature_type] = []
            features_by_type[feature_type].append(language_feature)
        
        return features_by_type

    @property
    def formatted_value(self):
        """
        Retourne la valeur formatée selon le type de caractéristique
        """
        if self.feature.is_boolean:
            return self.value.lower() in ['true', 'oui', '1', 'yes']
        return self.value.strip() if self.value else ''
