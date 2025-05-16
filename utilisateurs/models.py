from django.db import models
from django.contrib.auth.models import User
import uuid
import os

def user_avatar_path(instance, filename):
    # Générer un chemin unique pour chaque avatar
    ext = filename.split('.')[-1]
    filename = f"{uuid.uuid4()}.{ext}"
    return os.path.join('avatars', filename)

class Profile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    username = models.CharField(max_length=150, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # Utilisation de ImageField au lieu de URLField pour l'avatar
    avatar_url = models.URLField(blank=True, null=True)  # Gardé pour compatibilité
    full_name = models.CharField(max_length=255, blank=True, null=True)
    bio = models.TextField(blank=True, null=True)
    website = models.URLField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'profiles'
        verbose_name = 'Profil'
        verbose_name_plural = 'Profils'

    def __str__(self):
        return self.username or self.user.username or str(self.user_id)
    
    def save(self, *args, **kwargs):
        # Si username n'est pas défini, utiliser celui de l'utilisateur
        if not self.username and self.user:
            self.username = self.user.username
        super().save(*args, **kwargs)