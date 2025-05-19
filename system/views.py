from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET
from django.db import connection

@csrf_exempt
@require_GET
def healthcheck_view(request):
    """
    Vue de healthcheck qui vérifie:
    1. Que l'application est en cours d'exécution
    2. Que la connexion à la base de données fonctionne
    
    Retourne:
        200 OK si tout fonctionne
        503 Service Unavailable si un problème est détecté
    """
    # Vérifier la connexion à la base de données
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
            one = cursor.fetchone()[0]
            if one != 1:
                return JsonResponse({"status": "error", "message": "Database test failed"}, status=503)
    except Exception as e:
        return JsonResponse({"status": "error", "message": f"Database error: {str(e)}"}, status=503)
    
    # Tout est OK
    return JsonResponse({"status": "ok", "message": "Service is healthy"}, status=200)