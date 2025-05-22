from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from ..models import Languages

def get_field_value(request, slug, field_name):
    """
    API pour récupérer la valeur d'un champ spécifique d'un langage
    """
    language = get_object_or_404(Languages, slug=slug)
    
    # Vérifier si le champ existe
    if hasattr(language, field_name):
        value = getattr(language, field_name)
        return JsonResponse({
            'success': True,
            'field': field_name,
            'value': value
        })
    else:
        return JsonResponse({
            'success': False,
            'error': f"Le champ '{field_name}' n'existe pas"
        }, status=400)