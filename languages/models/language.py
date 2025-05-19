# languages/models/language.py
from django.db import models
from django.contrib.postgres.fields import ArrayField

class Languages(models.Model):
    name = models.CharField(max_length=255, unique=True)
    description = models.TextField(blank=True, null=True)
    short_description = models.TextField(blank=True, null=True)
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    logo_svg = models.TextField(blank=True, null=True) # SVG logo
    slug = models.CharField(max_length=255, unique=True)
    type = models.CharField(max_length=50, blank=True, null=True)
    used_for = models.TextField(blank=True, null=True)
    usage_rate = models.FloatField(blank=True, null=True)
    year_created = models.IntegerField(blank=True, null=True)
    creator = models.CharField(max_length=255, blank=True, null=True)
    popular_frameworks = ArrayField(models.CharField(max_length=255), blank=True, null=True)
    strengths = ArrayField(models.CharField(max_length=255), blank=True, null=True)
    is_open_source = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'languages'

    def __str__(self):
        return self.name

    def get_libraries_by_type(self, type_name):
        """
        Récupère les bibliothèques associées à ce langage, filtrées par type
        """
        from .library import Libraries, LibraryLanguages
    
        library_ids = LibraryLanguages.objects.filter(
            language_id=self.id
        ).values_list('library_id', flat=True)
    
        return Libraries.objects.filter(
            id__in=library_ids,
            technology_type=type_name
        ).order_by('name')

    @property
    def frameworks(self):
        return self.get_libraries_by_type('framework')
    
    @property
    def libraries(self):
        return self.get_libraries_by_type('library')
    
    @property
    def engines(self):
        return self.get_libraries_by_type('engine')
    
    @property
    def dev_tools(self):
        return self.get_libraries_by_type('tool')

class LanguageProposals(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    submitted_by = models.UUIDField(blank=True, null=True)
    status = models.CharField(max_length=50, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    reviewer_id = models.UUIDField(blank=True, null=True)
    review_notes = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'language_proposals'

    def __str__(self):
        return f"{self.name} ({self.status})"

class Corrections(models.Model):
    language_id = models.IntegerField(blank=True, null=True)
    field_name = models.CharField(max_length=50)
    current_value = models.TextField(blank=True, null=True)
    proposed_value = models.TextField()
    submitted_by = models.UUIDField(blank=True, null=True)
    status = models.CharField(max_length=50, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    reviewer_id = models.UUIDField(blank=True, null=True)
    review_notes = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'corrections'

    def __str__(self):
        return f"Correction for {self.field_name} ({self.status})"
    
class LanguagesFramework(models.Model):
    name = models.CharField(max_length=100)
    slug = models.CharField(unique=True, max_length=50)
    description = models.TextField()
    website = models.CharField(max_length=200)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    language_id = models.ForeignKey('Languages', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'languages_framework'

    def __str__(self):
        return self.name
