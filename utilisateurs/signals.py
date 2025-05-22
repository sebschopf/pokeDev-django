from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User
from .models import Profile

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    """Crée un profil pour chaque nouvel utilisateur."""
    if created:
        Profile.objects.create(user=instance, username=instance.username)

@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    """Sauvegarde le profil de l'utilisateur."""
    try:
        instance.profile.save()
    except User.profile.RelatedObjectDoesNotExist:
        # Si le profil n'existe pas, le créer correctement
        # IMPORTANT: Ne pas utiliser l'UUID comme clé primaire ici
        Profile.objects.create(
            user=instance,
            username=instance.username)
        # Ne pas définir l'ID manuellement, laissez Django le gérer