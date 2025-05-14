# languages/admin.py
from django.contrib import admin
from .models import ProgrammingLanguage, Framework

@admin.register(ProgrammingLanguage)
class ProgrammingLanguageAdmin(admin.ModelAdmin):
    list_display = ('name', 'creator', 'year_created', 'is_popular')
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ('name', 'description')
    list_filter = ('is_popular', 'year_created')

@admin.register(Framework)
class FrameworkAdmin(admin.ModelAdmin):
    list_display = ('name', 'language')
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ('name', 'description')
    list_filter = ('language',)