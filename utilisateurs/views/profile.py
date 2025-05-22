from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth.models import User
from ..models import Profile

@login_required
def profile(request):
    """
    Affiche le profil de l'utilisateurice connecté.
    """
    try:
        # Récupérer le profil de l'utilisateurice connecté
        user_profile = request.user.profile
        
        # Récupérer les expertises en langage via l'utilisateur et non le profil
        try:
            # Utilisez cette approche si LanguageExpertise a une relation avec User
            language_expertise = list(request.user.language_expertise.all())
            has_expertise = len(language_expertise) > 0
        except Exception as e:
            print(f"Erreur lors de la récupération des expertises: {str(e)}")
            language_expertise = []
            has_expertise = False
        
        context = {
            'nom_de_la_page': f"Profil de {user_profile.username or request.user.username}",
            'profile': user_profile, 
            'user_profile': True,
            'is_own_profile': True,
            'language_expertise': language_expertise,
            'has_expertise': has_expertise
        }
    except Profile.DoesNotExist:
        # Créer un profil pour l'utilisateurice si iel n'en a pas
        user_profile = Profile.objects.create(
            user=request.user,
            username=request.user.username
        )
        context = {
            'nom_de_la_page': f"Profil de {user_profile.username}",
            'profile': user_profile, 
            'user_profile': True,
            'message': "Votre profil a été créé. Vous pouvez maintenant le compléter.",
            'language_expertise': [],
            'has_expertise': False
        }
    except Exception as e:
        # Log l'erreur pour le débogage
        import traceback
        print(f"ERREUR DÉTAILLÉE: {str(e)}")
        print(traceback.format_exc())
        
        # Rediriger vers une page d'erreur simple
        from .error import error_view
        return error_view(request, 
            error_message="Une erreur s'est produite lors de l'accès à votre profil.",
            error_details=str(e)
        )
    
    return render(request, 'utilisateurs/profile.html', context)

@login_required
def edit_profile(request):
    """
    Permet à l'utilisateur de modifier son profil.
    """
    try:
        # Récupérer le profil de l'utilisateurice
        user_profile = request.user.profile
        
        if request.method == 'POST':
            from ..forms import ProfileForm
            form = ProfileForm(request.POST, request.FILES, instance=user_profile)
            if form.is_valid():
                profile = form.save(commit=False)
                # Si un nouvel avatar est téléchargé, mettre à jour avatar_url
                if 'avatar' in request.FILES:
                    profile.avatar_url = request.build_absolute_uri(profile.avatar.url)
                profile.save()
                messages.success(request, "Votre profil a été mis à jour avec succès.")
                return redirect('utilisateurs:profile')
        else:
            from ..forms import ProfileForm
            form = ProfileForm(instance=user_profile)
            
        context = {
            'nom_de_la_page': "Modifier votre profil",
            'form': form
        }
        return render(request, 'utilisateurs/edit_profile.html', context)
    
    except Profile.DoesNotExist:
        # Créer un profil pour l'utilisateurice si iel n'en a pas
        Profile.objects.create(user=request.user, username=request.user.username)
        messages.info(request, "Un profil a été créé pour vous. Vous pouvez maintenant le compléter.")
        return redirect('utilisateurs:edit_profile')

def view_profile(request, username):
    """
    Affiche le profil d'un utilisateurice spécifique.
    """
    user = get_object_or_404(User, username=username)
    try:
        user_profile = user.profile
    except Profile.DoesNotExist:
        user_profile = Profile.objects.create(user=user, username=user.username)
    
    context = {
        'nom_de_la_page': f"Profil de {user_profile.username or user.username}",
        'profile': user_profile,
        'user_profile': True,
        'is_own_profile': request.user.is_authenticated and request.user == user
    }
    return render(request, 'utilisateurs/profile.html', context)
