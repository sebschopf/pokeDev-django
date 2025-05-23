from django.shortcuts import render
from languages.models.accessibility import AccessibilityLevels, AccessibilityCriteria

def accessibility_methodology(request):
    """
    Vue pour afficher la méthodologie d'évaluation de l'accessibilité des langages.
    """
    # Récupérer les niveaux d'accessibilité et les critères
    accessibility_levels = AccessibilityLevels.objects.all().order_by('level_order')
    accessibility_criteria = AccessibilityCriteria.objects.all().order_by('-weight')
    
    context = {
        'accessibility_levels': accessibility_levels,
        'accessibility_criteria': accessibility_criteria,
    }
    
    return render(request, 'languages/accessibility_methodology.html', context)