from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.db.models import Count
from ..models import Profile

@login_required
def dashboard(request):
    """
    Tableau de bord personnalisé selon le rôle de l'utilisateurice.
    """
    user = request.user
    profile = user.profile
    
    # Données de base pour tous les utilisateurice
    context = {
        'user': user,
        'profile': profile,
    }
    
    # Données pour les utilisateurice vérifiés
    if profile.is_verified():
        # Nombre de langages et bibliothèques
        try:
            from languages.models.language import Languages
            from languages.models.library import Library
            
            context['languages_count'] = Languages.objects.count()
            context['libraries_count'] = Library.objects.count()
        except ImportError:
            context['languages_count'] = 0
            context['libraries_count'] = 0
    
    # Données pour les validateurs
    if profile.is_validator():
        # Corrections en attente
        try:
            from languages.models.language import Correction
            
            context['pending_corrections'] = Correction.objects.filter(status='pending').count()
        except ImportError:
            context['pending_corrections'] = 0
    
    # Données pour les administrateurices
    if profile.is_admin():
        # Statistiques générales
        context['users_count'] = Profile.objects.count()
        context['roles_distribution'] = Profile.objects.values('role').annotate(count=Count('role'))
        
        # Statistiques des langages
        try:
            from languages.models.language import StatsLanguages
            context['top_languages'] = StatsLanguages.objects.order_by('-views_count')[:5]
        except ImportError:
            # Si le modèle n'existe pas encore
            context['top_languages'] = []
    
    return render(request, 'utilisateurs/dashboard.html', context)
