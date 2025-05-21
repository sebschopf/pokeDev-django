# languages/admin/utils.py
from django.utils.html import format_html
from django.utils.safestring import mark_safe

def colored_status(status, status_dict=None):
    """
    Génère un badge coloré pour un statut donné
    
    Args:
        status (str): Le statut à afficher
        status_dict (dict, optional): Dictionnaire de mapping statut -> libellé
    
    Returns:
        str: HTML formaté pour le badge de statut
    """
    colors = {
        'pending': '#FF9800',  # Orange
        'approved': '#4CAF50',  # Vert
        'rejected': '#F44336',  # Rouge
    }
    color = colors.get(status, '#9E9E9E')  # Gris par défaut
    
    if status_dict:
        label = status_dict.get(status, status).upper()
    else:
        labels = {
            'pending': 'EN ATTENTE',
            'approved': 'APPROUVÉE',
            'rejected': 'REJETÉE',
        }
        label = labels.get(status, status.upper())
    
    return format_html(
        '<span style="background-color: {}; color: white; padding: 3px 7px; border-radius: 3px;">{}</span>',
        color,
        label
    )

def preview_text(text, max_length=50):
    """
    Crée un aperçu d'un texte en le tronquant si nécessaire
    
    Args:
        text (str): Le texte à prévisualiser
        max_length (int, optional): Longueur maximale avant troncature
    
    Returns:
        str: Texte tronqué avec des points de suspension si nécessaire
    """
    if not text:
        return ""
    return text[:max_length] + '...' if len(text) > max_length else text

def action_button(url, label, color, icon=None, margin_right=5):
    """
    Génère un bouton d'action HTML
    
    Args:
        url (str): URL de l'action
        label (str): Texte du bouton
        color (str): Code couleur hexadécimal
        icon (str, optional): Classe d'icône FontAwesome
        margin_right (int, optional): Marge à droite en pixels
    
    Returns:
        str: HTML formaté pour le bouton
    """
    icon_html = f'<i class="{icon}"></i> ' if icon else ''
    return format_html(
        '<a href="{}" class="button" style="background-color: {}; color: white; margin-right: {}px; '
        'padding: 3px 8px; border-radius: 4px; text-decoration: none;">'
        '{}{}</a>',
        url, color, margin_right, icon_html, label
    )
