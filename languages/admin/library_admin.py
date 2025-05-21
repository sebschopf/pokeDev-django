# languages/admin/library_admin.py
from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from ..models import Libraries, LibraryLanguages

class LibrariesAdmin(admin.ModelAdmin):
    list_display = ('name', 'technology_type', 'associated_languages', 'website_link', 'github_link')
    list_filter = ('technology_type',)
    search_fields = ('name', 'description')
    prepopulated_fields = {'slug': ('name',)}
    
    fieldsets = (
        ('Informations de base', {
            'fields': ('name', 'slug', 'description', 'technology_type')
        }),
        ('Ressources', {
            'fields': ('logo_path', 'website_url', 'github_url'),
            'classes': ('collapse',),
        }),
    )
    
    def associated_languages(self, obj):
        """Affiche les langages associés à cette bibliothèque"""
        languages = LibraryLanguages.objects.filter(library=obj).select_related('language')
        if not languages:
            return "Aucun langage"
        
        links = []
        for lib_lang in languages:
            links.append(format_html(
                '<a href="{}" style="margin-right: 5px; background-color: #e0e0e0; padding: 2px 6px; '
                'border-radius: 3px; text-decoration: none;">{}</a>',
                reverse('admin:languages_languages_change', args=[lib_lang.language.id]),
                lib_lang.language.name
            ))
        
        return format_html(''.join(links))
    associated_languages.short_description = "Langages"
    
    def website_link(self, obj):
        """Affiche un lien vers le site web"""
        if obj.website_url:
            return format_html(
                '<a href="{}" target="_blank" style="color: #2196F3;">'
                '<i class="fas fa-globe"></i> Site web</a>',
                obj.website_url
            )
        return "-"
    website_link.short_description = "Site web"
    
    def github_link(self, obj):
        """Affiche un lien vers GitHub"""
        if obj.github_url:
            return format_html(
                '<a href="{}" target="_blank" style="color: #333;">'
                '<i class="fab fa-github"></i> GitHub</a>',
                obj.github_url
            )
        return "-"
    github_link.short_description = "GitHub"

class LibraryLanguagesAdmin(admin.ModelAdmin):
    list_display = ('library', 'language', 'created_at')
    list_filter = ('language',)
    search_fields = ('library__name', 'language__name')
    autocomplete_fields = ['library', 'language']
