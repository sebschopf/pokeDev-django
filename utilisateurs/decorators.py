from django.shortcuts import redirect
from django.contrib import messages
from functools import wraps

def role_required(role_check):
    """
    Décorateur pour vérifier si l'utilisateur a le rôle requis
    role_check: une méthode du modèle Profile qui renvoie True si l'utilisateur a le rôle requis
    """
    def decorator(view_func):
        @wraps(view_func)
        def _wrapped_view(request, *args, **kwargs):
            if not request.user.is_authenticated:
                messages.error(request, "Vous devez être connecté pour accéder à cette page.")
                return redirect('utilisateurs:login')
            
            # Vérifier si l'utilisateur a le rôle requis
            check_method = getattr(request.user.profile, role_check, None)
            if check_method and check_method():
                return view_func(request, *args, **kwargs)
            else:
                messages.error(request, "Vous n'avez pas les permissions nécessaires pour accéder à cette page.")
                return redirect('utilisateurs:dashboard')
        
        return _wrapped_view
    return decorator