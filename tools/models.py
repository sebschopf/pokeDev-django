from django.db import models
from languages.models import Languages

class TechnologyCategory(models.Model):
    type = models.CharField(max_length=255, unique=True)
    icon_name = models.CharField(max_length=255, blank=True, null=True)
    color = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'technology_category'

    def __str__(self):
        return self.type

class TechnologySubtype(models.Model):
    category = models.ForeignKey(TechnologyCategory, on_delete=models.CASCADE, related_name='subtypes')
    name = models.CharField(max_length=255, db_index=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'technology_subtype'
        unique_together = ('category', 'name')
        indexes = [
            models.Index(fields=['name']),
        ]

    def __str__(self):
        return f"{self.name} ({self.category.type})"

class Tool(models.Model):
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True, null=True)
    usage = models.TextField(blank=True, null=True)
    type_id = models.IntegerField(null=True, blank=True)
    technology_category = models.ForeignKey(TechnologyCategory, on_delete=models.SET_NULL, null=True, blank=True, db_column='technology_category_id')
    technology_subtypes = models.ManyToManyField(TechnologySubtype, related_name='tools', blank=True)
    languages = models.ManyToManyField(Languages, related_name='tools', blank=True)
    official_website = models.URLField(blank=True, null=True)
    documentation_url = models.URLField(blank=True, null=True)
    is_open_source = models.BooleanField(default=False)
    license = models.CharField(max_length=255, blank=True, null=True)
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    author = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'tool'

    def __str__(self):
        return self.name