from django.apps import AppConfig

class UtilisateursConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'utilisateurs'
    verbose_name = 'Gestion des utilisateurs'

    def ready(self):
        import utilisateurs.signals  # Importe les signaux