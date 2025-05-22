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

class LanguageFeatures(models.Model):
    id = models.AutoField(primary_key=True)
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    feature = models.ForeignKey(Features, models.DO_NOTHING)
    value = models.CharField(max_length=255)
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
