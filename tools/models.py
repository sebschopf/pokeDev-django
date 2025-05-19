from django.db import models
from django.utils.text import slugify
import json

class Tool(models.Model):
    name = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255, unique=True, blank=True)
    description = models.TextField(blank=True, null=True)
    
    # Relation avec les langages
    language_id = models.IntegerField()
    
    # URLs
    official_website = models.URLField(blank=True, null=True)
    github_url = models.URLField(blank=True, null=True)
    documentation_url = models.URLField(blank=True, null=True)
    website_url = models.URLField(blank=True, null=True)
    
    # Métadonnées
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    popularity = models.FloatField(blank=True, null=True)
    is_open_source = models.BooleanField(default=True)
    version = models.CharField(max_length=50, blank=True, null=True)
    license = models.CharField(max_length=100, blank=True, null=True)
    
    # Catégorisation
    technology_type = models.CharField(max_length=100, blank=True, null=True)
    subtype = models.CharField(max_length=100, blank=True, null=True)
    
    # Caractéristiques
    features = models.JSONField(blank=True, null=True)
    unique_selling_point = models.TextField(blank=True, null=True)
    best_for = models.TextField(blank=True, null=True)
    used_for = models.TextField(blank=True, null=True)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'libraries'  # Utiliser la table 'libraries' existante
        managed = False  # Django ne gérera pas cette table
    
    def get_features_list(self):
        """Retourne les features sous forme de liste."""
        if not self.features:
            return []
        
        # Si features est déjà une liste
        if isinstance(self.features, list):
            return self.features
        
        # Si features est une chaîne JSON
        try:
            return json.loads(self.features)
        except (TypeError, json.JSONDecodeError):
            return []
    
    def __str__(self):
        return self.name