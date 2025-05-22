from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth.models import User
from ..models import Profile, UserRole
from ..forms import AdminProfileForm
from ..decorators import role_required

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
