from django.shortcuts import render, get_object_or_404
from .models import Profile

def profile(request):
    """
    Affiche le profil d'un utilisateur.
    """
    # récupérer l'utilisateur à afficher.
    # 'ID de l'utilisateur :
    # user_profile = UserProfile.objects.get(user_id=user_id) 
    # Ou si l'utilisateur est connecté :
    user_profile = request.user.userprofile #à adapter si necessaire

    #Pour l'instant on va faire au plus simple et afficher un message fixe
    context = {
        'nom_de_la_page': "Page de Profil",
        'message': "Bienvenue sur votre profil"
    }
    return render(request, 'utilisteurs/profile.html', context)  
