# languages/models/technology.py
from django.db import models

class TechnologyCategories(models.Model):
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'technology_categories'
        verbose_name_plural = 'technology categories'

    def __str__(self):
        return self.name

class TechnologySubtypes(models.Model):
    name = models.CharField(max_length=255)
    category = models.ForeignKey(TechnologyCategories, models.DO_NOTHING, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'technology_subtypes'

    def __str__(self):
        return self.name