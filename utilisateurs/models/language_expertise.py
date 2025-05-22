from django.db import models
from django.contrib.auth.models import User
from languages.models.language import Languages

class ExpertiseLevel(models.TextChoices):
    BEGINNER = 'beginner', 'Débutant'
    INTERMEDIATE = 'intermediate', 'Intermédiaire'
    ADVANCED = 'advanced', 'Avancé'
    SPECIALIST = 'specialist', 'Spécialiste'
    EXPERT = 'expert', 'Expert'

class LanguageExpertise(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='language_expertise')
    language = models.ForeignKey(Languages, on_delete=models.CASCADE, related_name='experts')
    expertise_level = models.CharField(
        max_length=20,
        choices=ExpertiseLevel.choices,
        default=ExpertiseLevel.INTERMEDIATE
    )
    notes = models.TextField(blank=True, null=True)
    
    # Ajout des champs created_at et updated_at s'ils sont nécessaires
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('user', 'language')
        verbose_name = 'Expertise en langage'
        verbose_name_plural = 'Expertises en langages'

    def __str__(self):
        return f"{self.user} - {self.language} ({self.get_expertise_level_display()})"
