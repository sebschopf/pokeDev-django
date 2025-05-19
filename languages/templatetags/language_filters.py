from django import template
from django.template.defaultfilters import stringfilter

register = template.Library()

@register.filter
@stringfilter
def split(value, arg):
    """
    Divise une chaîne par le séparateur spécifié.
    Usage: {{ value|split:"," }}
    """
    return value.split(arg)

@register.filter
@stringfilter
def strip(value):
    """
    Supprime les espaces au début et à la fin d'une chaîne.
    Usage: {{ value|strip }}
    """
    return value.strip()
