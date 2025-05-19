from django.db import models
from django.contrib.auth.models import User
import uuid
import os

def user_avatar_path(instance, filename):
    # Générer un chemin unique pour chaque avatar
    ext = filename.split('.')[-1]
    filename = f"{uuid.uuid4()}.{ext}"
    return os.path.join('avatars', filename)

# Définition des choix de rôles
class UserRole(models.TextChoices):
    VISITOR = 'visitor', 'Visiteurice'
    REGISTERED = 'registered', 'Utilisateurice enregistré.e'
    VERIFIED = 'verified', 'Utilisateurice vérifié.e'
    VALIDATOR = 'validator', 'Validateurice'
    LANGUAGE_REFERENT = 'language_referent', 'Référent.e linguistique'
    ADMIN = 'admin', 'Administrateurice'

class Profile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    username = models.CharField(max_length=150, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    avatar_url = models.URLField(blank=True, null=True)
    full_name = models.CharField(max_length=255, blank=True, null=True)
    bio = models.TextField(blank=True, null=True)
    website = models.URLField(blank=True, null=True)
    # Définition des choix de rôles /!\
    role = models.CharField(
        max_length=20,
        choices=UserRole.choices,
        default=UserRole.REGISTERED,
        verbose_name="Rôle de l'utilisateurice"
    )

    class Meta:
        managed = True
        db_table = 'profiles'
        verbose_name = 'Profil'
        verbose_name_plural = 'Profils'

    def __str__(self):
        return self.username or self.user.username or str(self.user_id)
    
    def save(self, *args, **kwargs):
        # Si username n'est pas défini, utiliser celui de l'utilisateurice
        if not self.username and self.user:
            self.username = self.user.username
        super().save(*args, **kwargs)

    # Méthodes de vérification des rôles
    def is_admin(self):
        return self.role == UserRole.ADMIN
    
    def is_validator(self):
        return self.role == UserRole.VALIDATOR or self.role == UserRole.ADMIN
    
    def is_verified(self):
        return self.role == UserRole.VERIFIED or self.is_validator()
    
    def is_language_referent(self):
        return self.role == UserRole.LANGUAGE_REFERENT or self.is_validator()
    
    # Méthodes de vérification des permissions
    def can_view_stats(self):
        return self.is_admin()
    
    def can_validate_content(self):
        return self.is_validator()
    
    def can_submit_new_content(self):
        return self.is_verified() or self.is_language_referent()
    
    def can_submit_corrections(self):
        return self.role != UserRole.VISITOR
    
    # Méthodes de vérification des rôles spécifiques pour le role de référent
    def is_language_expert(self, language_id):
        """Vérifie si l'utilisateurice est expert d'un langage spécifique."""
        return self.language_expertise.filter(language_id=language_id).exists()

    def get_expertise_languages(self):
        """Retourne tous les langages dont l'utilisateurice est expert.e."""
        return [expertise.language for expertise in self.language_expertise.all()]

    def add_language_expertise(self, language_id, level='specialist', notes=None):
        """Ajoute une expertise en langage pour l'utilisateurice."""
        from .language_expertise import LanguageExpertise
        expertise, created = LanguageExpertise.objects.get_or_create(
            user=self,
            language_id=language_id,
            defaults={
                'expertise_level': level,
                'notes': notes
            }
        )
        # Si l'expertise existe déjà, on met à jour les champs si nécessaire
        if not created and (level != expertise.expertise_level or notes != expertise.notes):
            expertise.expertise_level = level
            expertise.notes = notes
            expertise.save()
        return expertise
