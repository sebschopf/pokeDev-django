from django import template
from django.utils.safestring import mark_safe

register = template.Library()

@register.filter
def accessibility_level_color(level_number):
    """Retourne une classe CSS pour la couleur du niveau d'accessibilité"""
    colors = {
        1: 'bg-green-400',  # Débutant - vert
        2: 'bg-lime-400',   # Élémentaire - vert clair
        3: 'bg-yellow-400', # Intermédiaire - jaune
        4: 'bg-orange-400', # Avancé - orange
        5: 'bg-red-400'     # Expert - rouge
    }
    return colors.get(level_number, 'bg-gray-400')

@register.filter
def accessibility_score_class(score):
    """Retourne une classe CSS basée sur le score d'accessibilité"""
    if score is None:
        return 'score-unknown'
    
    if score >= 90:
        return 'score-excellent'
    elif score >= 75:
        return 'score-good'
    elif score >= 50:
        return 'score-average'
    elif score >= 25:
        return 'score-difficult'
    else:
        return 'score-very-difficult'

@register.filter
def accessibility_score_label(score):
    """Retourne un label pour le score d'accessibilité"""
    if score is None:
        return 'Non évalué'
    
    if score >= 90:
        return 'Très facile'
    elif score >= 75:
        return 'Facile'
    elif score >= 50:
        return 'Moyen'
    elif score >= 25:
        return 'Difficile'
    else:
        return 'Très difficile'

@register.filter
def accessibility_level_icon(level_number):
    """Retourne une icône pour le niveau d'accessibilité"""
    icons = {
        1: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>',
        2: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>',
        3: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>',
        4: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path></svg>',
        5: '<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>'
    }
    return mark_safe(icons.get(level_number, ''))