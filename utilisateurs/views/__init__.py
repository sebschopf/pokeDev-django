# Ce fichier importe et expose toutes les vues pour qu'elles soient accessibles via utilisateurs.views
from .profile import profile, edit_profile, view_profile
from .auth import login_view, register
from .dashboard import dashboard
from .admin import manage_roles, stats_view, edit_user_role
from .language_experts import manage_language_experts
from .error import error_view

# Exposer toutes les vues pour qu'elles soient importables directement depuis utilisateurs.views
__all__ = [
    'profile', 'edit_profile', 'view_profile',
    'login_view', 'register',
    'dashboard',
    'manage_roles', 'stats_view', 'edit_user_role',
    'manage_language_experts',
    'error_view'
]
