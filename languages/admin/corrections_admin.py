# languages/admin/corrections_admin.py
from django.contrib import admin, messages
from django.utils import timezone
from django.urls import reverse
from django.utils.html import format_html
from django.utils.safestring import mark_safe
from django.http import HttpResponseRedirect
from ..models import Corrections
from .utils import colored_status, preview_text, action_button

class CorrectionStatus:
    PENDING = 'pending'
    APPROVED = 'approved'
    REJECTED = 'rejected'
    
    choices = [
        (PENDING, 'En attente'),
        (APPROVED, 'Approuvée'),
        (REJECTED, 'Rejetée'),
    ]

class CorrectionsAdmin(admin.ModelAdmin):
    list_display = ('language', 'field', 'correction_text_preview', 'colored_status', 'created_at', 'quick_actions')
    list_filter = ('status', 'language', 'field')
    search_fields = ('field', 'correction_text', 'suggestion')
    readonly_fields = ('created_at', 'updated_at', 'user_id', 'language_field_value')
    actions = ['approve_corrections', 'reject_corrections']
    # Utiliser un menu déroulant pour le statut
    radio_fields = {"status": admin.HORIZONTAL}
    
    def colored_status(self, obj):
        status_dict = dict(Corrections.STATUS_CHOICES)
        return colored_status(obj.status, status_dict)
    colored_status.short_description = "Status"
    
    def correction_text_preview(self, obj):
        return preview_text(obj.correction_text)
    correction_text_preview.short_description = "Correction"
    
    def language_field_value(self, obj):
        if obj.language and obj.field and hasattr(obj.language, obj.field):
            current_value = getattr(obj.language, obj.field)
            if current_value:
                return format_html(
                    '<div style="background-color: #f0f0f0; padding: 10px; border-radius: 4px;">'
                    '<strong>Valeur actuelle:</strong><br>{}</div>',
                    mark_safe(current_value.replace('\n', '<br>') if isinstance(current_value, str) else current_value)
                )
            return "Aucune valeur"
        return "Champ non disponible"
    language_field_value.short_description = "Valeur actuelle"
    
    fieldsets = (
        ('Informations de base', {
            'fields': ('language', 'field', 'user_id', 'created_at', 'updated_at')
        }),
        ('Contenu', {
            'fields': ('language_field_value', 'correction_text', 'suggestion')
        }),
        ('Révision', {
            'fields': ('status',)
        }),
    )
    
    def approve_corrections(self, request, queryset):
        updated = 0
        errors = 0
        for correction in queryset.filter(status=CorrectionStatus.PENDING):
            try:
                language = correction.language
                field_name = correction.field
                if hasattr(language, field_name):
                    setattr(language, field_name, correction.correction_text)
                    language.save()
                    
                    correction.status = CorrectionStatus.APPROVED
                    correction.save()
                    updated += 1
                else:
                    errors += 1
            except Exception as e:
                errors += 1
                self.message_user(request, f"Erreur pour {correction}: {str(e)}", level=messages.ERROR)
        
        if updated > 0:
            self.message_user(request, f"{updated} corrections ont été approuvées avec succès.", level=messages.SUCCESS)
        if errors > 0:
            self.message_user(request, f"{errors} corrections n'ont pas pu être appliquées.", level=messages.WARNING)
    approve_corrections.short_description = "Approuver les corrections sélectionnées"
    
    def reject_corrections(self, request, queryset):
        count = queryset.filter(status=CorrectionStatus.PENDING).update(status=CorrectionStatus.REJECTED)
        self.message_user(request, f"{count} corrections ont été rejetées.", level=messages.INFO)
    reject_corrections.short_description = "Rejeter les corrections sélectionnées"
    
    def change_view(self, request, object_id, form_url='', extra_context=None):
        extra_context = extra_context or {}
        extra_context['show_approve_button'] = True
        return super().change_view(request, object_id, form_url, extra_context=extra_context)
    
    def response_change(self, request, obj):
        if "_approve" in request.POST:
            try:
                language = obj.language
                field_name = obj.field
                if hasattr(language, field_name):
                    setattr(language, field_name, obj.correction_text)
                    language.save()
                    obj.status = CorrectionStatus.APPROVED
                    obj.save()
                    self.message_user(request, f"La correction a été approuvée et le champ {field_name} du langage {language.name} a été mis à jour.", level=messages.SUCCESS)
                else:
                    self.message_user(request, f"Erreur: Le champ {field_name} n'existe pas dans le modèle Language.", level=messages.ERROR)
            except Exception as e:
                self.message_user(request, f"Erreur lors de l'approbation: {str(e)}", level=messages.ERROR)
            return HttpResponseRedirect(".")
        elif "_reject" in request.POST:
            obj.status = CorrectionStatus.REJECTED
            obj.save()
            self.message_user(request, "La correction a été rejetée.", level=messages.INFO)
            return HttpResponseRedirect(".")
        return super().response_change(request, obj)
    
    def save_model(self, request, obj, form, change):
        # Si le statut change à approuvé, mettre à jour la valeur dans le modèle Language
        if 'status' in form.changed_data and obj.status == CorrectionStatus.APPROVED:
            try:
                language = obj.language
                field_name = obj.field
                if hasattr(language, field_name):
                    setattr(language, field_name, obj.correction_text)
                    language.save()
                    self.message_user(request, f"Le champ {field_name} du langage {language.name} a été mis à jour avec succès.", level=messages.SUCCESS)
                else:
                    self.message_user(request, f"Erreur: Le champ {field_name} n'existe pas dans le modèle Language.", level=messages.ERROR)
            except Exception as e:
                self.message_user(request, f"Erreur lors de la mise à jour du langage: {str(e)}", level=messages.ERROR)
        
        super().save_model(request, obj, form, change)

    def quick_actions(self, obj):
        if obj.status == 'pending':
            return format_html(
                '{} {}',
                action_button(
                    f"{reverse('admin:languages_corrections_change', args=[obj.id])}?approve=1",
                    "Approuver",
                    "#4CAF50"
                ),
                action_button(
                    f"{reverse('admin:languages_corrections_change', args=[obj.id])}?reject=1",
                    "Rejeter",
                    "#f44336"
                )
            )
        elif obj.status == 'approved':
            return format_html('<span style="color: #4CAF50;">✓ Approuvée</span>')
        else:
            return format_html('<span style="color: #f44336;">✗ Rejetée</span>')
    quick_actions.short_description = "Actions rapides"
