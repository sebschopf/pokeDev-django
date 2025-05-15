# languages/admin.py
from django.contrib import admin
from .models import Languages, LanguagesFramework

@admin.register(Languages)
class LanguageAdmin(admin.ModelAdmin):
    list_display = ('name', 'creator', 'year_created', 'is_open_source')
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ('name', 'description')
    list_filter = ('is_open_source', 'year_created')

@admin.register(LanguagesFramework)
class FrameworkAdmin(admin.ModelAdmin):
    list_display = ('name', 'language_id')
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ('name', 'description')
    list_filter = ('language_id',)