from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import AuthenticationForm
from .models import Profile
from .forms import ProfileForm, CustomUserCreationForm
from django.contrib.auth.models import User

# Vues existantes (profile, edit_profile, view_profile)...

@login_required
def profile(request):
    """
    Affiche le profil de l'utilisateur connecté.
    """
    try:
        # Récupérer le profil de l'utilisateur connecté
        user_profile = request.user.profile
        context = {
            'nom_de_la_page': f"Profil de {user_profile.username or request.user.username}",
            'profile': user_profile, 
            'user_profile': True,  # Indique qu'un profil existe
            'is_own_profile': True  # afficher le bouton de modification
        }
    except Profile.DoesNotExist:
        # Créer un profil pour l'utilisateur s'il n'en a pas
        user_profile = Profile.objects.create(
            user=request.user,
            username=request.user.username
        )
        context = {
            'nom_de_la_page': f"Profil de {user_profile.username}",
            'profile': user_profile, 
            'user_profile': True,
            'message': "Votre profil a été créé. Vous pouvez maintenant le compléter."
        }
    
    return render(request, 'utilisateurs/profile.html', context)

@login_required
def edit_profile(request):
    """
    Permet à l'utilisateur de modifier son profil.
    """
    try:
        # Récupérer le profil de l'utilisateur
        user_profile = request.user.profile
        
        if request.method == 'POST':
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
            form = ProfileForm(instance=user_profile)
            
        context = {
            'nom_de_la_page': "Modifier votre profil",
            'form': form
        }
        return render(request, 'utilisateurs/edit_profile.html', context)
    
    except Profile.DoesNotExist:
        # Créer un profil pour l'utilisateur s'il n'en a pas
        Profile.objects.create(user=request.user, username=request.user.username)
        messages.info(request, "Un profil a été créé pour vous. Vous pouvez maintenant le compléter.")
        return redirect('utilisateurs:edit_profile')

def view_profile(request, username):
    """
    Affiche le profil d'un utilisateur spécifique.
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

# vues pour l'authentification

def login_view(request):
    """
    Vue personnalisée pour la connexion des utilisateurs.
    """
    if request.user.is_authenticated:
        return redirect('utilisateurs:profile')
        
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                messages.success(request, f"Bienvenue, {username}!")
                # Rediriger vers la page demandée ou le profil
                next_page = request.POST.get('next', 'utilisateurs:profile')
                return redirect(next_page)
            else:
                messages.error(request, "Nom d'utilisateur ou mot de passe invalide.")
        else:
            messages.error(request, "Nom d'utilisateur ou mot de passe invalide.")
    else:
        form = AuthenticationForm()
    
    return render(request, 'utilisateurs/login.html', {
        'form': form,
        'next': request.GET.get('next', '')
    })

def register(request):
    """
    Vue pour l'inscription d'un nouvel utilisateur.
    """
    if request.user.is_authenticated:
        return redirect('utilisateurs:profile')
        
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # Créer un profil pour le nouvel utilisateur
            Profile.objects.create(
                user=user,
                username=user.username,
                # d'autres champs peuvent être ajoutés ici si nécessaire
            )
            # Connecter l'utilisateur après l'inscription
            login(request, user)
            messages.success(request, "Votre compte a été créé avec succès!")
            return redirect('utilisateurs:profile')
    else:
        form = CustomUserCreationForm()
    
    return render(request, 'utilisateurs/register.html', {'form': form})