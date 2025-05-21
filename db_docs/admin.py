from django.contrib import admin
from django.http import HttpResponseRedirect
from django.urls import reverse
from .models import DatabaseDocumentation, Chapter, Section

@admin.register(DatabaseDocumentation)
class DatabaseDocumentationAdmin(admin.ModelAdmin):
    def has_add_permission(self, request):
        return False
    
    def has_delete_permission(self, request, obj=None):
        return False
    
    def has_change_permission(self, request, obj=None):
        return False
    
    def changelist_view(self, request, extra_context=None):
        # Rediriger vers la vue de documentation
        return HttpResponseRedirect(reverse('db_docs:index'))

@admin.register(Chapter)
class ChapterAdmin(admin.ModelAdmin):
    list_display = ('title', 'order', 'slug')
    prepopulated_fields = {'slug': ('title',)}
    search_fields = ('title', 'description')

@admin.register(Section)
class SectionAdmin(admin.ModelAdmin):
    list_display = ('title', 'chapter', 'order')
    list_filter = ('chapter',)
    search_fields = ('title', 'content', 'sql_example')
