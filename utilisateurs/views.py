from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth.models import User
from django.db.models import Count

# Importations des modèles
from .models import Profile, UserRole
from .models import LanguageExpertise
from .models import CorrectionComment
from .forms import ProfileForm, CustomUserCreationForm, AdminProfileForm
from .decorators import role_required

@login_required
def profile(request):
    """
    Affiche le profil de l'utilisateurice connecté.
    """
    try:
        # Récupérer le profil de l'utilisateurice connecté
        user_profile = request.user.profile
        context = {
            'nom_de_la_page': f"Profil de {user_profile.username or request.user.username}",
            'profile': user_profile, 
            'user_profile': True,  # Indique qu'un profil existe
            'is_own_profile': True  # afficher le bouton de modification
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
            'message': "Votre profil a été créé. Vous pouvez maintenant le compléter."
        }
    
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

# vues pour l'authentification

def login_view(request):
    """
    Vue personnalisée pour la connexion des utilisateurice.
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
        return redirect('utilisateurs:profile')
        
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
            return redirect('utilisateurs:profile')
    else:
        form = CustomUserCreationForm()
    
    return render(request, 'utilisateurs/register.html', {'form': form})

# Nouvelles vues pour le système de rôles

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
        from languages.models.language import Language
        from languages.models.library import Library
        
        context['languages_count'] = Language.objects.count()
        context['libraries_count'] = Library.objects.count()
    
    # Données pour les validateurs
    if profile.is_validator():
        # Corrections en attente
        from languages.models.language import Correction
        
        context['pending_corrections'] = Correction.objects.filter(status='pending').count()
    
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

@login_required
@role_required('is_validator')
def review_correction(request, correction_id):
    """
    Vue pour examiner une correction spécifique.
    Met en évidence les avis des experts du langage concerné.
    """
    from languages.models.language import Correction
    
    correction = get_object_or_404(Correction, id=correction_id)
    language = correction.language
    
    # Récupérer les experts du langage
    language_experts = LanguageExpertise.objects.filter(
        language=language
    ).select_related('user')
    
    # Traitement du formulaire
    if request.method == 'POST':
        action = request.POST.get('action')
        
        if action == 'comment':
            comment_content = request.POST.get('comment')
            if comment_content:
                CorrectionComment.objects.create(
                    correction=correction,
                    user=request.user,
                    content=comment_content
                )
                messages.success(request, "Votre commentaire a été ajouté.")
        
        elif action == 'approve':
            correction.status = 'approved'
            correction.status_note = request.POST.get('status_note', '')
            correction.save()
            messages.success(request, "La correction a été approuvée.")
            return redirect('languages:review_corrections')
        
        elif action == 'reject':
            correction.status = 'rejected'
            correction.status_note = request.POST.get('status_note', '')
            correction.save()
            messages.success(request, "La correction a été rejetée.")
            return redirect('languages:review_corrections')
    
    # Récupérer les commentaires existants sur cette correction
    comments = CorrectionComment.objects.filter(
        correction=correction
    ).select_related('user')
    
    # Identifier les commentaires des experts
    expert_user_ids = [expertise.user.id for expertise in language_experts]
    for comment in comments:
        comment.is_from_expert = comment.user.id in expert_user_ids
    
    context = {
        'correction': correction,
        'language': language,
        'language_experts': language_experts,
        'comments': comments,
        'nom_de_la_page': f"Examen de la correction #{correction.id}"
    }
    
    return render(request, 'languages/review_correction.html', context)

@login_required
@role_required('is_admin')
def manage_roles(request):
    """
    Permet aux administrateurices de gérer les rôles des utilisateurice.
    """
    profiles = Profile.objects.all().select_related('user')
    
    if request.method == 'POST':
        profile_id = request.POST.get('profile_id')
        new_role = request.POST.get('role')
        
        if profile_id and new_role:
            try:
                profile = Profile.objects.get(id=profile_id)
                profile.role = new_role
                profile.save()
                messages.success(request, f"Le rôle de {profile.username} a été mis à jour.")
            except Profile.DoesNotExist:
                messages.error(request, "Profil non trouvé.")
        
        return redirect('utilisateurs:manage_roles')
    
    context = {
        'profiles': profiles,
        'role_choices': UserRole.choices,
    }
    
    return render(request, 'utilisateurs/manage_roles.html', context)

@login_required
@role_required('can_view_stats')
def stats_view(request):
    """
    Vue des statistiques complètes, accessible uniquement aux administrateurices.
    """
    try:
        from languages.models.language import StatsLanguages
        languages_stats = StatsLanguages.objects.all()
    except ImportError:
        languages_stats = []
    
    try:
        from languages.models.language import StatsUsers
        users_stats = StatsUsers.objects.all()
    except ImportError:
        users_stats = []
    
    try:
        from languages.models.language import StatsSearches
        searches_stats = StatsSearches.objects.all()
    except ImportError:
        searches_stats = []
    
    context = {
        'languages_stats': languages_stats,
        'users_stats': users_stats,
        'searches_stats': searches_stats,
    }
    
    return render(request, 'utilisateurs/stats.html', context)

@login_required
@role_required('is_admin')
def edit_user_role(request, user_id):
    """
    Permet à l'administrateurice de modifier le rôle de l'utilisateurice spécifique.
    """
    user = get_object_or_404(User, id=user_id)
    profile = get_object_or_404(Profile, user=user)
    
    if request.method == 'POST':
        form = AdminProfileForm(request.POST, instance=profile)
        if form.is_valid():
            form.save()
            messages.success(request, f"Le rôle de {profile.username} a été mis à jour.")
            return redirect('utilisateurs:manage_roles')
    else:
        form = AdminProfileForm(instance=profile)
    
    context = {
        'form': form,
        'profile': profile,
        'nom_de_la_page': f"Modifier le rôle de {profile.username}"
    }
    
    return render(request, 'utilisateurs/edit_user_role.html', context)
