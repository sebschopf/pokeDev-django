from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.contrib import messages
from ..models import Languages, Corrections
from ..forms import DynamicCorrectionForm
import json

@login_required
def propose_correction(request, slug):
    language = get_object_or_404(Languages, slug=slug)
    
    if request.method == 'POST':
        # Vérifier si c'est une requête AJAX
        is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
        
        if is_ajax:
            try:
                # Récupérer le nombre de corrections
                corrections_count = int(request.POST.get('corrections_count', 1))
                success_count = 0
                errors = []
                
                # Traiter chaque correction
                for i in range(corrections_count):
                    field_name = f"field_{i}" if i > 0 else "field"
                    correction_text_name = f"correction_text_{i}" if i > 0 else "correction_text"
                    suggestion_name = f"suggestion_{i}" if i > 0 else "suggestion"
                    
                    field = request.POST.get(field_name)
                    correction_text = request.POST.get(correction_text_name)
                    suggestion = request.POST.get(suggestion_name)
                    
                    # Vérifier que tous les champs sont remplis
                    if not all([field, correction_text, suggestion]):
                        errors.append(f"Tous les champs sont obligatoires pour la correction #{i+1}")
                        continue
                    
                    # Créer une nouvelle correction
                    correction = Corrections.objects.create(
                        language=language,
                        field=field,
                        correction_text=correction_text,
                        suggestion=suggestion,
                        user=request.user
                    )
                    success_count += 1
                
                # Préparer la réponse
                if success_count > 0:
                    messages.success(request, f"{success_count} correction(s) soumise(s) avec succès.")
                    return JsonResponse({
                        'success': True,
                        'redirect_url': language.get_absolute_url(),
                        'message': f"{success_count} correction(s) soumise(s) avec succès."
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
            # Traitement standard du formulaire (non-AJAX)
            field = request.POST.get('field')
            correction_text = request.POST.get('correction_text')
            suggestion = request.POST.get('suggestion')
            
            # Créer une nouvelle correction
            correction = Corrections.objects.create(
                language=language,
                field=field,
                correction_text=correction_text,
                suggestion=suggestion,
                user=request.user
            )
            
            messages.success(request, "Votre correction a été soumise avec succès.")
            return redirect('languages:correction_detail', correction_id=correction.id)
    
    # Initialiser un formulaire vide
    form = DynamicCorrectionForm(language_id=language.id)
    
    return render(request, 'languages/propose_correction.html', {
        'language': language,
        'form': form
    })

@login_required
def correction_list(request):
    # Récupérer toutes les corrections ou filtrer selon les permissions
    corrections = Corrections.objects.all().order_by('-created_at')
    
    return render(request, 'languages/correction_list.html', {
        'corrections': corrections
    })

@login_required
def correction_detail(request, correction_id):
    correction = get_object_or_404(Corrections, id=correction_id)
    
    if request.method == 'POST':
        # Traitement des actions sur la correction (approuver, rejeter, etc.)
        action = request.POST.get('action')
        
        if action == 'approve':
            correction.status = 'approved'
            correction.reviewed_by = request.user
            correction.save()
            
            # Mettre à jour le langage avec la correction
            language = correction.language
            setattr(language, correction.field, correction.correction_text)
            language.save()
            
            messages.success(request, "La correction a été approuvée et appliquée.")
        
        elif action == 'reject':
            correction.status = 'rejected'
            correction.reviewed_by = request.user
            correction.save()
            
            messages.success(request, "La correction a été rejetée.")
        
        return redirect('languages:correction_list')
    
    return render(request, 'languages/correction_detail.html', {
        'correction': correction
    })

# API pour récupérer la valeur actuelle d'un champ
def get_field_value(request, slug, field_name):
    try:
        language = get_object_or_404(Languages, slug=slug)
        
        # Vérifier si le champ est un champ spécial
        if field_name.startswith('feature_'):
            # Extraire l'ID de la caractéristique
            feature_id = field_name.split('_')[1]
            from ..models import LanguageFeatures
            language_feature = LanguageFeatures.objects.get(language=language, feature_id=feature_id)
            value = f"Score: {language_feature.score}, Notes: {language_feature.notes}"
        
        elif field_name.startswith('accessibility_'):
            # Extraire l'ID du niveau d'accessibilité
            level_id = field_name.split('_')[1]
            from ..models import LanguageAccessibilityLevels
            language_accessibility = LanguageAccessibilityLevels.objects.get(
                language=language, 
                accessibility_level_id=level_id
            )
            value = f"Score: {language_accessibility.accessibility_score}, Notes: {language_accessibility.notes}"
        
        elif field_name == 'strengths':
            # Supposons que get_strengths() est une méthode du modèle Languages
            # qui renvoie une liste des points forts
            value = ", ".join(language.strengths) if hasattr(language, 'strengths') else "Non disponible"
        
        elif field_name == 'popular_frameworks':
            # Supposons que popular_frameworks est un champ JSON ou une liste
            value = ", ".join(language.popular_frameworks) if hasattr(language, 'popular_frameworks') else "Non disponible"
        
        elif field_name == 'tools':
            # Supposons que tools est un champ JSON
            value = json.dumps(language.tools, indent=2) if hasattr(language, 'tools') else "Non disponible"
        
        else:
            # Champ standard du modèle
            value = getattr(language, field_name, "Non disponible")
            
            # Formater la valeur si c'est un booléen
            if isinstance(value, bool):
                value = "Oui" if value else "Non"
        
        return JsonResponse({
            'success': True,
            'value': str(value)
        })
        
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        })