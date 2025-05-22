from django.urls import path
from django.contrib.auth import views as auth_views
from .views import (
    profile, edit_profile, view_profile,
    login_view, register,
    dashboard,
    manage_roles, stats_view, edit_user_role,
    manage_language_experts,
    error_view
)

app_name = 'utilisateurs'

urlpatterns = [
    # URLs de tableau de bord et gestion des rôles
    path('dashboard/', dashboard, name='dashboard'),
    path('manage-roles/', manage_roles, name='manage_roles'),
    path('stats/', stats_view, name='stats'),
    path('edit-user-role/<uuid:user_id>/', edit_user_role, name='edit_user_role'),
    path('manage-language-experts/', manage_language_experts, name='manage_language_experts'),

    # URLs de profil
    path('profile/', profile, name='profile'),
    path('profile/edit/', edit_profile, name='edit_profile'),
    path('profile/<str:username>/', view_profile, name='view_profile'),
    
    # URLs d'authentification
    path('login/', auth_views.LoginView.as_view(template_name='utilisateurs/login.html'), name='login'),
    path('register/', register, name='register'),
    path('logout/', auth_views.LogoutView.as_view(next_page='/'), name='logout'),
    
    # URLs de changement de mot de passe
    path('password_change/', auth_views.PasswordChangeView.as_view(
        template_name='utilisateurs/password_change.html',
        success_url='/utilisateurs/password_change/done/'
    ), name='password_change'),
    path('password_change/done/', auth_views.PasswordChangeDoneView.as_view(
        template_name='utilisateurs/password_change_done.html'
    ), name='password_change_done'),
    
    # URLs de réinitialisation de mot de passe
    path('password_reset/', auth_views.PasswordResetView.as_view(
        template_name='utilisateurs/password_reset.html',
        email_template_name='utilisateurs/password_reset_email.html',
        subject_template_name='utilisateurs/password_reset_subject.txt',
        success_url='/utilisateurs/password_reset/done/'
    ), name='password_reset'),
    path('password_reset/done/', auth_views.PasswordResetDoneView.as_view(
        template_name='utilisateurs/password_reset_done.html'
    ), name='password_reset_done'),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(
        template_name='utilisateurs/password_reset_confirm.html',
        success_url='/utilisateurs/reset/done/'
    ), name='password_reset_confirm'),
    path('reset/done/', auth_views.PasswordResetCompleteView.as_view(
        template_name='utilisateurs/password_reset_complete.html'
    ), name='password_reset_complete'),
]
