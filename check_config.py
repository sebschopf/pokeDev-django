import os
import sys
import django
from django.conf import settings

# Configurer Django
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "pokedev.settings")
django.setup()

def check_configuration():
    """Vérifie que la configuration Django est correcte pour le déploiement"""
    
    issues = []
    warnings = []
    
    # Vérifier les paramètres critiques
    if settings.DEBUG:
        issues.append("DEBUG est activé, il devrait être désactivé en production")
    
    if 'django-insecure' in settings.SECRET_KEY:
        issues.append("La clé secrète par défaut est utilisée, elle devrait être changée")
    
    if not settings.ALLOWED_HOSTS or settings.ALLOWED_HOSTS == ['*']:
        issues.append("ALLOWED_HOSTS n'est pas correctement configuré")
    
    # Vérifier les paramètres de sécurité
    if not settings.SECURE_PROXY_SSL_HEADER:
        warnings.append("SECURE_PROXY_SSL_HEADER n'est pas configuré")
    
    if not hasattr(settings, 'SECURE_HSTS_SECONDS') or settings.SECURE_HSTS_SECONDS < 31536000:
        warnings.append("SECURE_HSTS_SECONDS devrait être d'au moins 31536000 (1 an)")
    
    if not getattr(settings, 'SECURE_CONTENT_TYPE_NOSNIFF', False):
        warnings.append("SECURE_CONTENT_TYPE_NOSNIFF n'est pas activé")
    
    # Vérifier les applications installées
    if 'whitenoise.runserver_nostatic' not in settings.INSTALLED_APPS:
        warnings.append("whitenoise.runserver_nostatic n'est pas dans INSTALLED_APPS")
    
    # Vérifier les middlewares
    if 'whitenoise.middleware.WhiteNoiseMiddleware' not in settings.MIDDLEWARE:
        warnings.append("WhiteNoiseMiddleware n'est pas configuré dans MIDDLEWARE")
    
    # Afficher les résultats
    if issues:
        print("⚠️ PROBLÈMES CRITIQUES DÉTECTÉS :")
        for issue in issues:
            print(f"  ❌ {issue}")
    else:
        print("✅ Aucun problème critique détecté")
    
    if warnings:
        print("\n⚠️ AVERTISSEMENTS :")
        for warning in warnings:
            print(f"  ⚠️ {warning}")
    else:
        print("✅ Aucun avertissement")
    
    return len(issues) == 0

if __name__ == "__main__":
    print("Vérification de la configuration Django pour le déploiement...\n")
    if check_configuration():
        print("\n✅ Configuration valide pour le déploiement")
        sys.exit(0)
    else:
        print("\n❌ Des problèmes ont été détectés dans la configuration")
        sys.exit(1)
