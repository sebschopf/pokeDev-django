from django.db import models

class LanguageExpertise(models.Model):
    """
    Modèle qui associe un utilisateurice à un langage comme spécialiste/expert.e.
    Un utilisateurice peut être expert.e de plusieurs langages et un langage peut avoir plusieurs experts.
    """
    # Utiliser une chaîne pour la référence au modèle Profile
    user = models.ForeignKey('utilisateurs.Profile', on_delete=models.CASCADE, related_name='language_expertise')
    # Utiliser le nom correct du modèle Languages (au pluriel)
    language = models.ForeignKey('languages.Languages', on_delete=models.CASCADE, related_name='experts')
    expertise_level = models.CharField(max_length=20, choices=[
        ('specialist', 'Spécialiste'),
        ('expert', 'Expert.e'),
        ('maintainer', 'Mainteneur.euse'),
    ], default='specialist')
    notes = models.TextField(blank=True, null=True, help_text="Notes sur l'expertise (certifications, expérience, etc.)")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = "Expertise en langage"
        verbose_name_plural = "Expertises en langages"
        unique_together = ('user', 'language')  # Un utilisateurice ne peut être expert d'un langage qu'une seule fois

    def __str__(self):
        return f"{self.user.username} - {self.language.name} ({self.get_expertise_level_display()})"
