# languages/views_corrections.py
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.utils import timezone
from django.contrib import messages
from django.db.models import Q
from .models.corrections import Corrections
from .models import Languages
from .forms import ReviewCorrectionForm, SubmitCorrectionForm

def has_validator_permission(user):
    """Vérifie si l'utilisateur a les permissions de validateur ou d'admin"""
    return user.is_superuser or hasattr(user, 'user_role') and user.user_role in ['admin', 'validator']

@login_required
def correction_list(request):
    """Vue pour lister les demandes de correction"""
    if not has_validator_permission(request.user):
        messages.error(request, "Vous n'avez pas les permissions nécessaires pour accéder à cette page.")
        return redirect('home')
    
    status_filter = request.GET.get('status', '')
    
    corrections = Corrections.objects.all()
    if status_filter:
        corrections = corrections.filter(status=status_filter)
    
    context = {
        'corrections': corrections,
        'status_choices': [('pending', 'En attente'), ('approved', 'Approuvée'), ('rejected', 'Rejetée')],
        'current_status': status_filter
    }
    return render(request, 'languages/corrections_list.html', context)

@login_required
def correction_detail(request, correction_id):
    """Vue pour afficher et traiter une demande de correction"""
    if not has_validator_permission(request.user):
        messages.error(request, "Vous n'avez pas les permissions nécessaires pour accéder à cette page.")
        return redirect('home')
    
    correction = get_object_or_404(Corrections, id=correction_id)
    
    if request.method == 'POST':
        form = ReviewCorrectionForm(request.POST, instance=correction)
        if form.is_valid():
            review = form.save(commit=False)
            # Mettre à jour les champs manuellement
            review.status = form.cleaned_data['status']
            review.suggestion = form.cleaned_data['suggestion']
            review.updated_at = timezone.now()
            review.save()
            
            status_text = "approuvée" if review.status == 'approved' else "rejetée"
            messages.success(request, f"La demande de correction a été {status_text}.")
            
            # Si approuvée, mettre à jour la valeur dans le modèle Language
            if review.status == 'approved':
                language = correction.language
                field_name = correction.field
                if hasattr(language, field_name):
                    setattr(language, field_name, correction.correction_text)
                    language.save()
            
            return redirect('languages:correction_list')
    else:
        form = ReviewCorrectionForm(instance=correction)
    
    context = {
        'correction': correction,
        'form': form
    }
    return render(request, 'languages/corrections_detail.html', context)

@login_required
def propose_correction(request, slug):
    """Vue pour proposer une correction"""
    language = get_object_or_404(Languages, slug=slug)
    
    if request.method == 'POST':
        form = SubmitCorrectionForm(request.POST)
        if form.is_valid():
            correction = form.save(commit=False)
            correction.language = language
            correction.status = 'pending'
            
            # Définir les dates
            now = timezone.now()
            correction.created_at = now
            correction.updated_at = now
            
            # Gérer l'UUID de l'utilisateur
            if hasattr(request.user, 'id'):
                correction.user_id = request.user.id
            
            # Récupérer la valeur actuelle du champ si nécessaire
            field_name = form.cleaned_data['field']
            if hasattr(language, field_name):
                current_value = getattr(language, field_name)
                # Si votre modèle a un champ pour stocker la valeur actuelle, utilisez-le
                # Par exemple: correction.current_value = current_value
            
            correction.save()
            messages.success(request, "Votre proposition de correction a été soumise avec succès.")
            return redirect('languages:detail', slug=slug)
    else:
        form = SubmitCorrectionForm()
    
    return render(request, 'languages/propose_correction.html', {
        'form': form,
        'language': language
    })