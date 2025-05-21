from django.db import models
from django.urls import reverse

class DatabaseDocumentation(models.Model):
    """Modèle proxy pour l'administration"""
    class Meta:
        verbose_name = "Documentation BDD"
        verbose_name_plural = "Documentation BDD"
        managed = False  # Pas de table en base de données
        
    def __str__(self):
        return "Documentation de la base de données"

class Chapter(models.Model):
    """Chapitre de la documentation de la base de données"""
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    order = models.PositiveIntegerField(default=0)
    description = models.TextField(blank=True)
    
    class Meta:
        ordering = ['order', 'title']
    
    def __str__(self):
        return self.title
    
    def get_absolute_url(self):
        return reverse('db_docs:chapter_detail', kwargs={'slug': self.slug})

class Section(models.Model):
    """Section d'un chapitre"""
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, related_name='sections')
    title = models.CharField(max_length=200)
    content = models.TextField()
    sql_example = models.TextField(blank=True, help_text="Exemple de requête SQL liée à cette section")
    order = models.PositiveIntegerField(default=0)
    
    class Meta:
        ordering = ['order', 'title']
    
    def __str__(self):
        return f"{self.chapter.title} - {self.title}"
