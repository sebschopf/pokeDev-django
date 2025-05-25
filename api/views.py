from django.http import JsonResponse, HttpResponse
from django.template.loader import render_to_string
from django.shortcuts import get_object_or_404
from languages.models import Languages

# ===== MENU MOBILE =====
def mobile_menu_partial(request):
    """
    Vue pour charger le menu mobile de façon asynchrone
    Optimise les performances en ne chargeant le menu que quand nécessaire
    """
    context = {
        'user': request.user,
        'request': request,
    }
    
    html = render_to_string('base/partials/mobile-menu.html', context, request=request)
    return HttpResponse(html, content_type='text/html; charset=utf-8') # Pour éviter les problèmes d'encodage

def mobile_menu_partial_json(request):
    """
    Version JSON du menu mobile (plus robuste pour les erreurs)
    """
    try:
        context = {
            'user': request.user,
            'request': request,
        }
        
        html = render_to_string('base/partials/mobile-menu.html', context, request=request)
        
        return JsonResponse({
            'success': True,
            'html': html
        })
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)

# ===== LANGUAGES API =====
def get_field_value(request, slug, field_name):
    """
    API pour récupérer la valeur d'un champ spécifique d'un langage
    """
    language = get_object_or_404(Languages, slug=slug)
    
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

# ===== SEARCH API (pour plus tard) =====
def search_suggestions(request):
    """
    API pour les suggestions de recherche en temps réel
    """
    query = request.GET.get('q', '').strip()
    
    if len(query) < 2:
        return JsonResponse({'suggestions': []})
    
    # Recherche dans les langages
    languages = Languages.objects.filter(
        name__icontains=query
    )[:5]
    
    suggestions = [
        {
            'type': 'language',
            'name': lang.name,
            'url': f'/languages/{lang.slug}/',
            'description': lang.short_description
        }
        for lang in languages
    ]
    
    return JsonResponse({'suggestions': suggestions})

# ===== HEALTH CHECK =====
def health_check(request):
    """
    Health check pour monitoring
    """
    return JsonResponse({
        'status': 'ok',
        'service': 'PokeDev API',
        'version': '1.0.0'
    })
