# languages/views_corrections.py
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.utils import timezone
from django.contrib import messages
from django.db.models import Q
from django.http import JsonResponse
from .models.corrections import Corrections
from .models import Languages
from .forms import ReviewCorrectionForm, DynamicCorrectionForm

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
            review.reviewed_by = request.user
            review.reviewed_at = timezone.now()
            review.save()
            
            status_text = "approuvée" if review.status == 'approved' else "rejetée"
            messages.success(request, f"La demande de correction a été {status_text}.")
            
            # Si approuvée, mettre à jour la valeur dans le modèle Language
            if review.status == 'approved':
                language = correction.language
                field_name = correction.field
                
                # Gérer les champs spéciaux (listes)
                if field_name in ['strengths', 'popular_frameworks']:
                    # Convertir la chaîne en liste
                    try:
                        # Supposer que la valeur est au format "item1, item2, item3"
                        value_list = [item.strip() for item in correction.correction_text.split(',')]
                        setattr(language, field_name, value_list)
                    except Exception as e:
                        messages.error(request, f"Erreur lors de la mise à jour du champ {field_name}: {e}")
                else:
                    # Champ standard
                    if hasattr(language, field_name):
                        setattr(language, field_name, correction.correction_text)
                
                try:
                    language.save()
                    messages.success(request, f"Le langage {language.name} a été mis à jour avec succès.")
                except Exception as e:
                    messages.error(request, f"Erreur lors de la mise à jour du langage: {e}")
            
            return redirect('languages:correction_list')
    else:
        form = ReviewCorrectionForm(instance=correction)
    
    # Récupérer la valeur actuelle du champ
    current_value = "Non disponible"
    if hasattr(correction.language, correction.field):
        current_value = getattr(correction.language, correction.field)
    
    context = {
        'correction': correction,
        'form': form,
        'current_value': current_value
    }
    return render(request, 'languages/corrections_detail.html', context)

@login_required
def propose_correction(request, slug):
    """Vue pour proposer une correction"""
    language = get_object_or_404(Languages, slug=slug)
    
    if request.method == 'POST':
        # Vérifier si c'est une requête AJAX pour plusieurs corrections
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            try:
                corrections_count = int(request.POST.get('corrections_count', 0))
                success = True
                errors = []
                
                for i in range(corrections_count):
                    field = request.POST.get(f'field_{i}')
                    correction_text = request.POST.get(f'correction_text_{i}')
                    suggestion = request.POST.get(f'suggestion_{i}')
                    
                    if field and correction_text:
                        correction = Corrections(
                            language=language,
                            field=field,
                            correction_text=correction_text,
                            suggestion=suggestion,
                            status='pending',
                            created_at=timezone.now(),
                            updated_at=timezone.now()
                        )
                        
                        # Gérer l'UUID de l'utilisateur
                        if hasattr(request.user, 'id'):
                            correction.user_id = request.user.id
                        
                        correction.save()
                    else:
                        success = False
                        errors.append(f"Correction {i+1}: Champ et nouvelle valeur requis")
                
                if success:
                    messages.success(request, f"{corrections_count} propositions de correction ont été soumises avec succès.")
                    return JsonResponse({
                        'success': True,
                        'redirect_url': language.get_absolute_url()
                    })
                else:
                    return JsonResponse({
                        'success': False,
                        'errors': errors
                    })
                    
            except Exception as e:
                return JsonResponse({
                    'success': False,
                    'errors': str(e)
                })
        else:
            # Traitement standard pour une seule correction
            form = DynamicCorrectionForm(request.POST)
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
                
                correction.save()
                messages.success(request, "Votre proposition de correction a été soumise avec succès.")
                return redirect('languages:detail', slug=slug)
    else:
        form = DynamicCorrectionForm()
    
    return render(request, 'languages/propose_correction.html', {
        'form': form,
        'language': language
    })