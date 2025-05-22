# languages/admin/accessibility_admin.py
from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from ..models.accessibility import AccessibilityLevels, AccessibilityCriteria, LanguageAccessibilityLevels, LanguageAccessibilityEvaluations

class AccessibilityLevelsAdmin(admin.ModelAdmin):
    list_display = ('level_number', 'name', 'estimated_learning_time', 'level_order', 'languages_count')
    search_fields = ('name', 'description')
    ordering = ('level_order',)
    
    def languages_count(self, obj):
        """Affiche le nombre de langages associés à ce niveau d'accessibilité"""
        count = LanguageAccessibilityLevels.objects.filter(accessibility_level=obj).count()
        if count > 0:
            return format_html(
                '<a href="{}?accessibility_level__id__exact={}">{} langages</a>',
                reverse('admin:languages_languageaccessibilitylevels_changelist'),
                obj.id,
                count
            )
        return "Aucun langage"
    languages_count.short_description = "Langages"

class AccessibilityCriteriaAdmin(admin.ModelAdmin):
    list_display = ('name', 'weight', 'evaluations_count')
    search_fields = ('name', 'description')
    ordering = ('-weight', 'name')
    
    def evaluations_count(self, obj):
        """Affiche le nombre d'évaluations utilisant ce critère"""
        count = LanguageAccessibilityEvaluations.objects.filter(criteria=obj).count()
        if count > 0:
            return format_html(
                '<a href="{}?criteria__id__exact={}">{} évaluations</a>',
                reverse('admin:languages_languageaccessibilityevaluations_changelist'),
                obj.id,
                count
            )
        return "Aucune évaluation"
    evaluations_count.short_description = "Évaluations"

class LanguageAccessibilityLevelsAdmin(admin.ModelAdmin):
    list_display = ('language', 'accessibility_level', 'accessibility_score', 'score_indicator')
    list_filter = ('accessibility_level', 'language')
    search_fields = ('language__name', 'notes')
    autocomplete_fields = ('language', 'accessibility_level')
    
    def score_indicator(self, obj):
        """Affiche un indicateur visuel du score d'accessibilité"""
        if obj.accessibility_score is None:
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
    score_indicator.short_description = "Indicateur"
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        """Personnalise les champs de sélection des clés étrangères"""
        if db_field.name == "accessibility_level":
            kwargs["queryset"] = AccessibilityLevels.objects.all().order_by('level_order')
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

class LanguageAccessibilityEvaluationsAdmin(admin.ModelAdmin):
    # Modifier les champs affichés pour correspondre à la structure réelle
    list_display = ('get_language', 'criteria', 'score', 'score_indicator')
    list_filter = ('criteria', 'language_accessibility_level')
    search_fields = ('language_accessibility_level__language__name', 'justification')
    autocomplete_fields = ('language_accessibility_level', 'criteria')
    
    def get_language(self, obj):
        """Récupère le langage associé au niveau d'accessibilité"""
        if hasattr(obj.language_accessibility_level, 'language'):
            return obj.language_accessibility_level.language
        return "N/A"
    get_language.short_description = "Langage"
    get_language.admin_order_field = 'language_accessibility_level__language__name'
    
    def score_indicator(self, obj):
        """Affiche un indicateur visuel du score"""
        if obj.score is None:
            return '-'
        
        score = float(obj.score)
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
    score_indicator.short_description = "Indicateur"
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        """Personnalise les champs de sélection des clés étrangères"""
        if db_field.name == "criteria":
            kwargs["queryset"] = AccessibilityCriteria.objects.all().order_by('-weight')
        return super().formfield_for_foreignkey(db_field, request, **kwargs)