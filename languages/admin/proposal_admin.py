# languages/admin/proposal_admin.py
from django.contrib import admin
from django.utils import timezone
from django.urls import reverse
from django.utils.html import format_html
from django.http import HttpResponseRedirect
from django.utils.text import slugify
from ..models import LanguageProposals, Languages
from .utils import colored_status, action_button

class LanguageProposalsAdmin(admin.ModelAdmin):
    list_display = ('name', 'colored_status', 'created_at', 'quick_actions')
    list_filter = ('status',)
    search_fields = ('name', 'description')
    readonly_fields = ('created_at', 'updated_at', 'submitted_by')
    
    fieldsets = (
        ('Informations de base', {
            'fields': ('name', 'description', 'submitted_by', 'created_at')
        }),
        ('Révision', {
            'fields': ('status', 'reviewer_id', 'review_notes')
        }),
    )
    
    def colored_status(self, obj):
        return colored_status(obj.status)
    colored_status.short_description = "Status"
    
    def quick_actions(self, obj):
        if obj.status == 'pending':
            return format_html(
                '{} {}',
                action_button(
                    f"{reverse('admin:languages_languageproposals_change', args=[obj.id])}?approve=1",
                    "Approuver",
                    "#4CAF50"
                ),
                action_button(
                    f"{reverse('admin:languages_languageproposals_change', args=[obj.id])}?reject=1",
                    "Rejeter",
                    "#f44336"
                )
            )
        elif obj.status == 'approved':
            # Vérifier si un langage a été créé à partir de cette proposition
            try:
                language = Languages.objects.get(name=obj.name)
                return format_html(
                    '<span style="color: #4CAF50;">✓ Approuvée</span> - '
                    '<a href="{}" style="color: #2196F3;">Voir le langage</a>',
                    reverse('admin:languages_languages_change', args=[language.id])
                )
            except Languages.DoesNotExist:
                return format_html(
                    '<span style="color: #4CAF50;">✓ Approuvée</span> - '
                    '<a href="{}?create_language=1" style="color: #2196F3;">Créer le langage</a>',
                    reverse('admin:languages_languageproposals_change', args=[obj.id])
                )
        else:
            return format_html('<span style="color: #f44336;">✗ Rejetée</span>')
    quick_actions.short_description = "Actions rapides"
    
    def response_change(self, request, obj):
        if "approve" in request.GET:
            obj.status = 'approved'
            obj.reviewer_id = request.user.id if hasattr(request.user, 'id') else None
            obj.updated_at = timezone.now()
            obj.save()
            self.message_user(request, f"La proposition '{obj.name}' a été approuvée.")
            return HttpResponseRedirect(".")
        elif "reject" in request.GET:
            obj.status = 'rejected'
            obj.reviewer_id = request.user.id if hasattr(request.user, 'id') else None
            obj.updated_at = timezone.now()
            obj.save()
            self.message_user(request, f"La proposition '{obj.name}' a été rejetée.")
            return HttpResponseRedirect(".")
        elif "create_language" in request.GET and obj.status == 'approved':
            # Créer un nouveau langage à partir de la proposition
            language = Languages(
                name=obj.name,
                description=obj.description,
                slug=slugify(obj.name),
                # Autres champs par défaut
            )
            language.save()
            self.message_user(request, f"Le langage '{language.name}' a été créé avec succès.")
            return HttpResponseRedirect(reverse('admin:languages_languages_change', args=[language.id]))
        
        return super().response_change(request, obj)
