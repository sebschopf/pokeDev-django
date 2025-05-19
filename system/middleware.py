from django.http import JsonResponse

class HealthCheckMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Court-circuiter tout le traitement Django pour les healthchecks
        if request.path == '/health/':
            return JsonResponse({"status": "ok", "message": "Service is healthy"})
        return self.get_response(request)