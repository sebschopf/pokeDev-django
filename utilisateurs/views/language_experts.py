from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from ..models import Profile, LanguageExpertise
from ..decorators import role_required

@login_required
@role_required('is_admin')
def manage_language_experts(request):
    """
    Permet aux administrateurices de gérer les experts de langages.
    """
    try:
        from languages.models.language import Languages
        
        # Récupérer tous les langages et les profils
        languages = Languages.objects.all().order_by('name')
        profiles = Profile.objects.filter(role__in=['verified', 'validator', 'admin']).select_related('user')
        
        if request.method == 'POST':
            user_id = request.POST.get('user_id')
            language_id = request.POST.get('language_id')
            expertise_level = request.POST.get('expertise_level')
            action = request.POST.get('action')
            
            if user_id and language_id:
                try:
                    profile = Profile.objects.get(id=user_id)
                    
                    if action == 'add':
                        profile.add_language_expertise(
                            language_id=language_id,
                            level=expertise_level,
                            notes=request.POST.get('notes', '')
                        )
                        messages.success(request, f"Expertise ajoutée pour {profile.username}.")
                    elif action == 'remove':
                        LanguageExpertise.objects.filter(user=profile, language_id=language_id).delete()
                        messages.success(request, f"Expertise supprimée pour {profile.username}.")
                except Profile.DoesNotExist:
                    messages.error(request, "Profil non trouvé.")
                except Languages.DoesNotExist:
                    messages.error(request, "Langage non trouvé.")
            
            return redirect('utilisateurs:manage_language_experts')
        
        # Récupérer toutes les expertises existantes
        expertises = LanguageExpertise.objects.all().select_related('user', 'language')
        
        context = {
            'languages': languages,
            'profiles': profiles,
            'expertises': expertises,
            'expertise_levels': LanguageExpertise._meta.get_field('expertise_level').choices,
            'nom_de_la_page': "Gestion des experts de langages"
        }
        
        return render(request, 'utilisateurs/manage_language_experts.html', context)
    
    except ImportError:
        messages.error(request, "Le modèle Language n'est pas disponible. Veuillez vérifier l'installation de l'application languages.")
        return redirect('utilisateurs:dashboard')
