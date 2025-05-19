from django import template

register = template.Library()

@register.filter
def split_by(value, key):
    """
    Divise une chaîne par le séparateur spécifié.
    Usage: {{ value|split_by:"," }}
    """
    return value.split(key) if value else []

@register.filter
def strip(value):
    """
    Supprime les espaces en début et fin de chaîne.
    Usage: {{ value|strip }}
    """
    return value.strip() if value else value