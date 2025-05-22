# languages/views_api.py
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from .models import Languages

def get_field_value(request, slug, field_name):
    """API pour récupérer la valeur actuelle d'un champ d'un langage"""
    language = get_object_or_404(Languages, slug=slug)
    
    try:
        # Vérifier si le champ existe
        if hasattr(language, field_name):
            value = getattr(language, field_name)
            
            # Traiter les types spéciaux
            if field_name in ['strengths', 'popular_frameworks'] and isinstance(value, list):
                value = ', '.join(value)
            
            return JsonResponse({
                'success': True,
                'value': value
            })
        else:
            return JsonResponse({
                'success': False,
                'error': f"Le champ '{field_name}' n'existe pas"
            })
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        })