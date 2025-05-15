# languages/models/library.py
from django.db import models
from .language import Languages

class Libraries(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    language = models.ForeignKey(Languages, models.DO_NOTHING, blank=True, null=True)
    technology_type = models.CharField(max_length=50, blank=True, null=True)
    website_url = models.URLField(blank=True, null=True)
    github_url = models.URLField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'libraries'
        verbose_name_plural = 'libraries'

    def __str__(self):
        return self.name

class LibraryLanguages(models.Model):
    library = models.ForeignKey(Libraries, models.DO_NOTHING)
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'library_languages'
        unique_together = (('library', 'language'),)

    def __str__(self):
        return f"{self.library} - {self.language}"