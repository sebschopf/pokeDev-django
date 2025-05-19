from django.contrib import admin
from .models import (
    Languages, Corrections, LanguageProposals, LanguagesFramework,
    Libraries, LibraryLanguages,
    TechnologyCategories, TechnologySubtypes,
    UsageCategories, LanguageUsage
)

@admin.register(Languages)
class LanguagesAdmin(admin.ModelAdmin):
    list_display = ('name', 'creator', 'year_created', 'type')
    search_fields = ('name', 'creator', 'description')
    list_filter = ('type', 'year_created', 'is_open_source')
    prepopulated_fields = {'slug': ('name',)}

@admin.register(Corrections)
class CorrectionsAdmin(admin.ModelAdmin):
    list_display = ('language_id', 'field_name', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('field_name', 'current_value', 'proposed_value')
    readonly_fields = ('created_at', 'updated_at')

@admin.register(LanguageProposals)
class LanguageProposalsAdmin(admin.ModelAdmin):
    list_display = ('name', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('name', 'description')
    readonly_fields = ('created_at', 'updated_at')

@admin.register(Libraries)
class LibrariesAdmin(admin.ModelAdmin):
    list_display = ('name', 'language', 'technology_type')
    list_filter = ('technology_type',)
    search_fields = ('name', 'description')

@admin.register(TechnologyCategories)
class TechnologyCategoriesAdmin(admin.ModelAdmin):
    list_display = ('name', 'created_at')
    search_fields = ('name', 'description')

@admin.register(TechnologySubtypes)
class TechnologySubtypesAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'created_at')
    list_filter = ('category',)
    search_fields = ('name', 'description')

@admin.register(UsageCategories)
class UsageCategoriesAdmin(admin.ModelAdmin):
    list_display = ('name', 'created_at')
    search_fields = ('name', 'description')

@admin.register(LanguageUsage)
class LanguageUsageAdmin(admin.ModelAdmin):
    list_display = ('language', 'category', 'created_at')
    list_filter = ('category',)
    search_fields = ('language__name', 'category__name')

@admin.register(LibraryLanguages)
class LibraryLanguagesAdmin(admin.ModelAdmin):
    list_display = ('library', 'language', 'created_at')
    search_fields = ('library__name', 'language__name')

@admin.register(LanguagesFramework)
class LanguagesFrameworkAdmin(admin.ModelAdmin):
    list_display = ('name', 'language_id', 'website')
    search_fields = ('name', 'description')
    prepopulated_fields = {'slug': ('name',)}
