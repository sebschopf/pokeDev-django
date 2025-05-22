from django.contrib import admin
from django.urls import reverse
from django.utils.html import format_html
from django.utils.safestring import mark_safe
from django.http import HttpResponse, HttpResponseRedirect
import json
from ..models import Languages, Corrections, LanguagesFramework, LibraryLanguages
from ..models.accessibility import AccessibilityLevels, LanguageAccessibilityLevels
from .utils import action_button
from .mixins.language_admin_mixins import (
    LanguageDisplayMixin,
    LanguageActionsMixin,
    LanguageFormMixin
)

class LanguagesAdmin(LanguageDisplayMixin, LanguageActionsMixin, LanguageFormMixin, admin.ModelAdmin):
    """
    Administration des langages de programmation.
    Cette classe utilise plusieurs mixins pour organiser le code:
    - LanguageDisplayMixin: Méthodes d'affichage (indicateurs, liens, etc.)
    - LanguageActionsMixin: Actions personnalisées (export, mise en avant, etc.)
    - LanguageFormMixin: Personnalisation des formulaires
    """
    list_display = ('name', 'creator', 'year_created', 'type', 'is_open_source', 'usage_indicator', 'accessibility_indicator', 'view_corrections', 'view_on_site_link')
    list_filter = ('type', 'year_created', 'is_open_source', 'default_accessibility_level')
    search_fields = ('name', 'creator', 'description', 'short_description')
    prepopulated_fields = {'slug': ('name',)}
    list_per_page = 20
    save_on_top = True
    
    # Organisation des champs en sections logiques - CORRIGÉ selon la structure réelle de la base de données
    fieldsets = (
        ('Informations de base', {
            'fields': ('name', 'slug', 'creator', 'year_created', 'type', 'is_open_source')
        }),
        ('Description', {
            'fields': ('short_description', 'description'),
            'classes': ('collapse',),
        }),
        ('Ressources', {
            'fields': ('logo_path', 'logo_svg'),
            'classes': ('collapse',),
        }),
        ('Caractéristiques techniques', {
            'fields': ('used_for', 'usage_rate', 'strengths', 'popular_frameworks'),
            'classes': ('collapse',),
        }),
        ('Accessibilité', {
            'fields': ('default_accessibility_level', 'accessibility_score'),
            'classes': ('collapse',),
            'description': 'Paramètres d\'accessibilité du langage'
        }),
    )
    
    # Champs en lecture seule pour les statistiques
    readonly_fields = ('last_updated', 'corrections_count', 'frameworks_count', 'libraries_count', 'accessibility_levels_summary')
    
    # Définir les ressources Media pour inclure JS et CSS personnalisés
    class Media:
        css = {
            'all': ('admin/css/custom_admin.css',)
        }
        js = ('admin/js/svg_preview.js',)
    
    def usage_indicator(self, obj):
        """Affiche un indicateur visuel du taux d'utilisation"""
        if not hasattr(obj, 'usage_rate') or obj.usage_rate is None:
            return '-'
        
        rate = float(obj.usage_rate)
        if rate > 10:
            color = '#4CAF50'  # Vert
        elif rate > 5:
            color = '#FF9800'  # Orange
        else:
            color = '#9E9E9E'  # Gris
            
        return format_html(
            '<div style="background-color: {}; width: {}px; height: 10px; border-radius: 5px;" title="{}%"></div>',
            color, min(rate * 10, 100), rate
        )
    usage_indicator.short_description = "Popularité"
    
    def accessibility_indicator(self, obj):
        """Affiche un indicateur visuel du score d'accessibilité"""
        if not hasattr(obj, 'accessibility_score') or obj.accessibility_score is None:
            return '-'
        
        score = float(obj.accessibility_score)
        if score >= 75:
            color = '#4CAF50'  # Vert
        elif score >= 50:
            color = '#FF9800'  # Orange
        else:
            color = '#F44336'  # Rouge
            
        return format_html(
            '<div style="background-color: {}; width: {}px; height: 10px; border-radius: 5px;" title="{}%"></div>',
            color, min(score, 100), score
        )
    accessibility_indicator.short_description = "Accessibilité"
    
    def view_corrections(self, obj):
        """Affiche un lien vers les corrections avec compteur"""
        corrections_count = Corrections.objects.filter(language=obj).count()
        pending_count = Corrections.objects.filter(language=obj, status='pending').count()
        
        if pending_count > 0:
            return action_button(
                f"{reverse('admin:languages_corrections_changelist')}?language__id__exact={obj.id}&status__exact=pending",
                f"{corrections_count} corrections ({pending_count} en attente)",
                '#ff9800'
            )
        elif corrections_count > 0:
            return action_button(
                f"{reverse('admin:languages_corrections_changelist')}?language__id__exact={obj.id}",
                f"{corrections_count} corrections",
                '#2196F3'
            )
        return format_html('<span style="color: #9E9E9E;">Aucune correction</span>')
    view_corrections.short_description = "Corrections"
    
    def view_on_site_link(self, obj):
        """Lien vers la page publique du langage"""
        url = reverse('languages:detail', kwargs={'slug': obj.slug})
        return action_button(
            url,
            "Voir sur le site",
            '#2196F3',
            'fas fa-external-link-alt'
        )
    view_on_site_link.short_description = "Page publique"
    
    def view_on_site(self, obj):
        """URL pour le bouton 'voir sur le site' intégré"""
        return reverse('languages:detail', kwargs={'slug': obj.slug})
    
    def corrections_count(self, obj):
        """Nombre total de corrections pour ce langage"""
        count = Corrections.objects.filter(language=obj).count()
        pending = Corrections.objects.filter(language=obj, status='pending').count()
        approved = Corrections.objects.filter(language=obj, status='approved').count()
        rejected = Corrections.objects.filter(language=obj, status='rejected').count()
        
        return format_html(
            '<div>Total: <strong>{}</strong></div>'
            '<div style="color: #FF9800;">En attente: <strong>{}</strong></div>'
            '<div style="color: #4CAF50;">Approuvées: <strong>{}</strong></div>'
            '<div style="color: #F44336;">Rejetées: <strong>{}</strong></div>',
            count, pending, approved, rejected
        )
    corrections_count.short_description = "Statistiques des corrections"
    
    def frameworks_count(self, obj):
        """Nombre de frameworks associés à ce langage"""
        count = LanguagesFramework.objects.filter(language_id=obj.id).count()
        if count > 0:
            return format_html(
                '<a href="{}?language_id__exact={}" style="color: #2196F3;">'
                '<strong>{}</strong> frameworks</a>',
                reverse('admin:languages_languagesframework_changelist'),
                obj.id,
                count
            )
        return "Aucun framework"
    frameworks_count.short_description = "Frameworks"
    
    def libraries_count(self, obj):
        """Nombre de bibliothèques associées à ce langage"""
        count = LibraryLanguages.objects.filter(language=obj).count()
        if count > 0:
            return format_html(
                '<a href="{}?language__id__exact={}" style="color: #2196F3;">'
                '<strong>{}</strong> bibliothèques</a>',
                reverse('admin:languages_librarylanguages_changelist'),
                obj.id,
                count
            )
        return "Aucune bibliothèque"
    libraries_count.short_description = "Bibliothèques"
    
    def accessibility_levels_summary(self, obj):
        """Résumé des niveaux d'accessibilité pour ce langage"""
        levels = LanguageAccessibilityLevels.objects.filter(language=obj).select_related('accessibility_level')
        
        if not levels:
            return "Aucun niveau d'accessibilité défini"
        
        level_colors = {
            1: '#4CAF50',  # Vert
            2: '#8BC34A',  # Vert clair
            3: '#FFEB3B',  # Jaune
            4: '#FF9800',  # Orange
            5: '#F44336',  # Rouge
        }
        
        html = '<div style="display: flex; flex-direction: column; gap: 10px;">'
        
        for level in levels:
            level_number = level.accessibility_level.level_number
            color = level_colors.get(level_number, '#9E9E9E')
            
            html += f'''
            <div style="display: flex; align-items: center; gap: 10px;">
                <div style="background-color: {color}; color: white; padding: 3px 7px; border-radius: 3px; min-width: 120px; text-align: center;">
                    {level.accessibility_level.name}
                </div>
                <div style="flex-grow: 1; background-color: #f0f0f0; height: 10px; border-radius: 5px; overflow: hidden;">
                    <div style="background-color: {color}; width: {level.accessibility_score}%; height: 100%;"></div>
                </div>
                <div style="min-width: 50px; text-align: right;">
                    {level.accessibility_score}%
                </div>
            </div>
            '''
        
        html += '</div>'
        
        # Ajouter un lien pour gérer les niveaux d'accessibilité
        html += f'''
        <div style="margin-top: 10px;">
            <a href="{reverse('admin:languages_languageaccessibilitylevels_changelist')}?language__id__exact={obj.id}" 
               style="color: #2196F3;">
               Gérer les niveaux d'accessibilité
            </a>
        </div>
        '''
        
        return mark_safe(html)
    accessibility_levels_summary.short_description = "Niveaux d'accessibilité"
    
    def last_updated(self, obj):
        """Date de dernière mise à jour"""
        return obj.updated_at if hasattr(obj, 'updated_at') else "Non disponible"
    last_updated.short_description = "Dernière mise à jour"
    
    # Actions personnalisées
    actions = ['export_as_json', 'mark_as_featured', 'update_svg_logo', 'recalculate_accessibility_score']
    
    def export_as_json(self, request, queryset):
        """Exporte les langages sélectionnés au format JSON"""
        languages_data = []
        for language in queryset:
            language_dict = {
                'id': language.id,
                'name': language.name,
                'creator': language.creator,
                'year_created': language.year_created,
                'type': language.type,
                'is_open_source': language.is_open_source,
                'description': language.description,
                'short_description': language.short_description,
                'logo_svg': language.logo_svg,
                'strengths': language.strengths,
                'popular_frameworks': language.popular_frameworks,
                'accessibility_score': language.accessibility_score,
                'default_accessibility_level_id': language.default_accessibility_level_id,
            }
            languages_data.append(language_dict)
        
        response = HttpResponse(json.dumps(languages_data, indent=4), content_type='application/json')
        response['Content-Disposition'] = 'attachment; filename="languages_export.json"'
        
        self.message_user(request, f"{len(queryset)} langages ont été exportés au format JSON.")
        return response
    export_as_json.short_description = "Exporter les langages sélectionnés (JSON)"
    
    def mark_as_featured(self, request, queryset):
        """Marque les langages sélectionnés comme mis en avant"""
        # Supposons que vous ayez un champ 'is_featured' dans votre modèle
        updated = queryset.update(is_featured=True)
        self.message_user(request, f"{updated} langages ont été marqués comme mis en avant.")
    mark_as_featured.short_description = "Marquer comme mis en avant"
    
    def update_svg_logo(self, request, queryset):
        """Action pour mettre à jour les logos SVG des langages sélectionnés"""
        selected = queryset.count()
        if selected == 1:
            # Rediriger vers le formulaire d'édition avec focus sur le champ logo_svg
            language = queryset.first()
            return HttpResponseRedirect(
                f"{reverse('admin:languages_languages_change', args=[language.id])}#id_logo_svg"
            )
        else:
            self.message_user(request, 
                "Veuillez sélectionner un seul langage pour mettre à jour son logo SVG.", 
                level='warning')
    update_svg_logo.short_description = "Mettre à jour le logo SVG"
    
    def recalculate_accessibility_score(self, request, queryset):
        """Recalcule le score d'accessibilité global basé sur les niveaux d'accessibilité"""
        updated = 0
        for language in queryset:
            try:
                # Récupérer le niveau d'accessibilité par défaut
                if language.default_accessibility_level_id:
                    # Trouver le score correspondant dans LanguageAccessibilityLevels
                    level = LanguageAccessibilityLevels.objects.get(
                        language=language,
                        accessibility_level_id=language.default_accessibility_level_id
                    )
                    
                    # Mettre à jour le score global
                    language.accessibility_score = level.accessibility_score
                    language.save()
                    updated += 1
            except LanguageAccessibilityLevels.DoesNotExist:
                self.message_user(
                    request, 
                    f"Erreur pour {language.name}: Niveau d'accessibilité par défaut non trouvé dans les évaluations.", 
                    level='warning'
                )
        
        self.message_user(request, f"Score d'accessibilité recalculé pour {updated} langages.")
    recalculate_accessibility_score.short_description = "Recalculer les scores d'accessibilité"
    
    # Personnalisation de l'interface de changement
    def change_view(self, request, object_id, form_url='', extra_context=None):
        extra_context = extra_context or {}
        language = self.get_object(request, object_id)
        
        if language:
            # Ajouter des liens contextuels
            extra_context['additional_links'] = [
                {
                    'title': 'Voir les corrections',
                    'url': f"{reverse('admin:languages_corrections_changelist')}?language__id__exact={language.id}",
                    'icon': 'fas fa-edit'
                },
                {
                    'title': 'Voir les frameworks',
                    'url': f"{reverse('admin:languages_languagesframework_changelist')}?language_id__exact={language.id}",
                    'icon': 'fas fa-cubes'
                },
                {
                    'title': 'Voir les bibliothèques',
                    'url': f"{reverse('admin:languages_librarylanguages_changelist')}?language__id__exact={language.id}",
                    'icon': 'fas fa-book'
                },
                {
                    'title': 'Gérer les niveaux d\'accessibilité',
                    'url': f"{reverse('admin:languages_languageaccessibilitylevels_changelist')}?language__id__exact={language.id}",
                    'icon': 'fas fa-universal-access'
                },
                {
                    'title': 'Voir sur le site',
                    'url': reverse('languages:detail', kwargs={'slug': language.slug}),
                    'icon': 'fas fa-external-link-alt',
                    'target': '_blank'
                }
            ]
            
            # Ajouter un aperçu du logo SVG s'il existe
            if language.logo_svg:
                extra_context['svg_preview'] = mark_safe(language.logo_svg)
        
        return super().change_view(request, object_id, form_url, extra_context=extra_context)
    
    # Personnalisation du formulaire
    def get_form(self, request, obj=None, **kwargs):
        form = super().get_form(request, obj, **kwargs)
        
        # Ajouter des aides contextuelles
        if 'description' in form.base_fields:
            form.base_fields['description'].help_text = "Description détaillée du langage. Peut contenir du HTML basique."
        
        if 'short_description' in form.base_fields:
            form.base_fields['short_description'].help_text = "Brève description du langage (max 200 caractères)."
        
        if 'logo_svg' in form.base_fields:
            form.base_fields['logo_svg'].help_text = mark_safe(
                "Code SVG du logo. <button type='button' onclick='previewSVG()' class='button'>Prévisualiser</button>"
            )
        
        if 'default_accessibility_level' in form.base_fields:
            form.base_fields['default_accessibility_level'].help_text = "Niveau d'accessibilité recommandé pour ce langage."
        
        if 'accessibility_score' in form.base_fields:
            form.base_fields['accessibility_score'].help_text = "Score global d'accessibilité (0-100). Peut être calculé automatiquement."
        
        return form