from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey

class SEOConfig(models.Model):
    """Configuration SEO globale du site"""
    site_name = models.CharField(max_length=100, default="PokeDev")
    site_description = models.TextField(default="Cartes interactives des langages de programmation")
    default_keywords = models.CharField(max_length=255, default="langages programmation, frameworks, développement")
    og_image = models.URLField(blank=True, null=True)
    twitter_handle = models.CharField(max_length=50, blank=True, null=True)
    
    class Meta:
        verbose_name = "Configuration SEO"
        verbose_name_plural = "Configurations SEO"
    
    def __str__(self):
        return f"Config SEO - {self.site_name}"

class SEOMetadata(models.Model):
    """Métadonnées SEO pour n'importe quel objet"""
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey('content_type', 'object_id')
    
    # Métadonnées personnalisées (optionnelles)
    custom_title = models.CharField(max_length=60, blank=True, null=True)
    custom_description = models.CharField(max_length=160, blank=True, null=True)
    custom_keywords = models.CharField(max_length=255, blank=True, null=True)
    
    # Contrôles SEO
    no_index = models.BooleanField(default=False)
    no_follow = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ('content_type', 'object_id')
        verbose_name = "Métadonnée SEO"
        verbose_name_plural = "Métadonnées SEO"
    
    def __str__(self):
        return f"SEO - {self.content_object}"
