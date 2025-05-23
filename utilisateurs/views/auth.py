from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import AuthenticationForm
from ..models import Profile
from ..forms import CustomUserCreationForm

def login_view(request):
    """
    Vue personnalisée pour la connexion des utilisateurice.
    """
    if request.user.is_authenticated:
        return redirect('/languages')
        
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(username=username, password=password)
            if user is not None:
                login(request, user)
                messages.success(request, f"Bienvenue, {username}!")
                
                # Simplifier la redirection - toujours aller à languages:list
                return redirect('/languages')
            else:
                messages.error(request, "Nom d'utilisateurice ou mot de passe invalide.")
        else:
            messages.error(request, "Nom d'utilisateurice ou mot de passe invalide.")
    else:
        form = AuthenticationForm()
    
    return render(request, 'utilisateurs/login.html', {
        'form': form,
        'next': request.GET.get('next', '')
    })

def register(request):
    """
    Vue pour l'inscription d'un nouvel utilisateurice.
    """
    if request.user.is_authenticated:
        # Correction ici aussi
        return redirect('/languages')
        
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            # Créer un profil pour le nouvel utilisateurice
            Profile.objects.create(
                user=user,
                username=user.username,
                # d'autres champs peuvent être ajoutés ici si nécessaire
            )
            # Connecter l'utilisateurice après l'inscription
            login(request, user)
            messages.success(request, "Votre compte a été créé avec succès!")
            # Correction ici aussi
            return redirect('/languages')
    else:
        form = CustomUserCreationForm()
    
    return render(request, 'utilisateurs/register.html', {'form': form})
