# languages/models/usage.py
from django.db import models
from .language import Languages

class UsageCategories(models.Model):
    name = models.CharField(unique=True, max_length=255)
    created_at = models.DateTimeField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'usage_categories'
    
    def __str__(self):
        return self.name

class LanguageUsage(models.Model):
    language = models.ForeignKey(Languages, models.DO_NOTHING, blank=True, null=True)
    category = models.ForeignKey(UsageCategories, models.DO_NOTHING, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'language_usage'
        unique_together = (('language', 'category'),)
    
    def __str__(self):
        return f"{self.language} - {self.category}"