from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from ..models import Languages, Corrections

@login_required
def propose_correction(request, slug):
    language = get_object_or_404(Languages, slug=slug)
    
    if request.method == 'POST':
        # Traitement du formulaire de correction
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
        
        # Rediriger vers la page de détail de la correction
        return redirect('languages:correction_detail', correction_id=correction.id)
    
    return render(request, 'languages/propose_correction.html', {
        'language': language
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
        
        elif action == 'reject':
            correction.status = 'rejected'
            correction.reviewed_by = request.user
            correction.save()
        
        return redirect('languages:correction_list')
    
    return render(request, 'languages/correction_detail.html', {
        'correction': correction
    })