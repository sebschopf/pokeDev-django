from django.contrib import admin
from ..models import LanguageFeatures, LanguageFeatureValues

class LanguageFeatureValuesInline(admin.TabularInline):
    model = LanguageFeatureValues
    extra = 1
    autocomplete_fields = ['language']

@admin.register(LanguageFeatures)
class LanguageFeaturesAdmin(admin.ModelAdmin):
    list_display = ('name', 'feature_type', 'is_boolean', 'has_multiple_values', 'importance_weight', 'display_order')
    list_filter = ('feature_type', 'is_boolean', 'has_multiple_values')
    search_fields = ('name', 'description')
    prepopulated_fields = {'slug': ('name',)}
    inlines = [LanguageFeatureValuesInline]

@admin.register(LanguageFeatureValues)
class LanguageFeatureValuesAdmin(admin.ModelAdmin):
    list_display = ('language', 'feature', 'value')
    list_filter = ('feature', 'language')
    search_fields = ('language__name', 'feature__name', 'value', 'notes')
    autocomplete_fields = ['language', 'feature']