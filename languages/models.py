# languages/models.py
from django.db import models

class ProgrammingLanguage(models.Model):
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    creator = models.CharField(max_length=100, blank=True)
    year_created = models.IntegerField(null=True, blank=True)
    description = models.TextField()
    logo = models.ImageField(upload_to='logos/', blank=True, null=True)
    website = models.URLField(blank=True)
    github_repo = models.URLField(blank=True)
    is_popular = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name
    
    class Meta:
        ordering = ['name']

class Framework(models.Model):
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    language = models.ForeignKey(ProgrammingLanguage, on_delete=models.CASCADE, related_name='frameworks')
    description = models.TextField()
    website = models.URLField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.name