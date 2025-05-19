from django.db import models
from django.conf import settings

class CorrectionComment(models.Model):
    """
    Modèle pour les commentaires sur les corrections.
    Permet aux utilisateurices et aux validateurices de discuter des corrections.
    """
    # Utiliser le nom correct du modèle Corrections (au pluriel)
    correction = models.ForeignKey('languages.Corrections', on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='correction_comments')
    content = models.TextField(verbose_name="Contenu du commentaire")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        verbose_name = "Commentaire de correction"
        verbose_name_plural = "Commentaires de corrections"
        ordering = ['created_at']
    
    def __str__(self):
        return f"Commentaire de {self.user.username} sur la correction #{self.correction.id}"
