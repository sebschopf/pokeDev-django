from django import template
from django.utils.safestring import mark_safe

register = template.Library()

@register.filter
def score_color_class(score):
    """
    Retourne la classe Tailwind pour la couleur selon le score
    Usage: {{ score|score_color_class }}
    """
    if score is None:
        return 'bg-gray-500'
    
    if score >= 80:
        return 'bg-green-500'
    elif score >= 60:
        return 'bg-yellow-500'
    elif score >= 40:
        return 'bg-orange-500'
    else:
        return 'bg-red-500'

@register.filter
def score_bg_class(score):
    """
    Retourne la classe de background selon le score
    Usage: {{ score|score_bg_class }}
    """
    if score is None:
        return 'bg-gray-100'
    
    if score >= 80:
        return 'bg-green-100'
    elif score >= 60:
        return 'bg-yellow-100'
    elif score >= 40:
        return 'bg-orange-100'
    else:
        return 'bg-red-100'

@register.filter
def score_badge_class(score):
    """
    Retourne la classe pour les badges selon le score
    Usage: {{ score|score_badge_class }}
    """
    if score is None:
        return 'bg-gray-400'
    
    if score >= 75:
        return 'bg-green-400'
    elif score >= 50:
        return 'bg-yellow-400'
    else:
        return 'bg-red-400'

@register.filter
def score_interpretation(score):
    """
    Retourne l'interprétation textuelle du score
    Usage: {{ score|score_interpretation }}
    """
    if score is None:
        return 'Non évalué'
    
    if score >= 80:
        return 'Très accessible - Recommandé pour ce niveau'
    elif score >= 60:
        return 'Modérément accessible - Quelques défis à prévoir'
    elif score >= 40:
        return 'Peu accessible - Nécessite de l\'expérience'
    else:
        return 'Difficile d\'accès - Pour experts uniquement'
