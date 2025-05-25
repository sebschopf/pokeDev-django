from django.shortcuts import render
from django.http import JsonResponse, HttpResponse
from django.template.loader import render_to_string

def mobile_menu_partial(request):
    """
    Vue pour charger le menu mobile de façon asynchrone
    Optimise les performances en ne chargeant le menu que quand nécessaire
    """
    # Contexte nécessaire pour le menu mobile
    context = {
        'user': request.user,
        'request': request,
    }
    
    # Rendu du template partiel
    html = render_to_string('base/partials/mobile-menu.html', context, request=request)
    
    # Retour en HTML simple pour fetch()
    return HttpResponse(html, content_type='text/html')

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
