from django.db import models
from django.utils.text import slugify

class LanguagesFramework(models.Model):
    """
    Modèle pour les frameworks associés aux langages de programmation
    """
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, verbose_name="Nom")
    slug = models.SlugField(max_length=100, unique=True, verbose_name="Slug")
    description = models.TextField(blank=True, null=True, verbose_name="Description")
    website = models.URLField(blank=True, null=True, verbose_name="Site web")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Date de création")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Date de mise à jour")
    language = models.ForeignKey('Languages', models.DO_NOTHING, related_name='frameworks', verbose_name="Langage")

    class Meta:
        managed = False
        db_table = 'languages_framework'
        verbose_name = "Framework"
        verbose_name_plural = "Frameworks"
        ordering = ['name']

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)