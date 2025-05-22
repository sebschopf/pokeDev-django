from django.contrib import admin
from .models.profile import Profile
from .models.language_expertise import LanguageExpertise
from .models.comment import CorrectionComment

@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ('username', 'full_name', 'role', 'created_at')
    search_fields = ('username', 'full_name')
    list_filter = ('role', 'created_at')
    readonly_fields = ('user', 'created_at', 'updated_at')

@admin.register(LanguageExpertise)
class LanguageExpertiseAdmin(admin.ModelAdmin):
    list_display = ('user', 'language', 'expertise_level', 'created_at')
    list_filter = ('expertise_level', 'created_at')
    search_fields = ('user__username', 'language__name', 'notes')
    # autocomplete_fields = ['user', 'language']

@admin.register(CorrectionComment)
class CorrectionCommentAdmin(admin.ModelAdmin):
    list_display = ('correction', 'user', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('correction__language__name', 'user__username', 'content')
    readonly_fields = ('created_at', 'updated_at')
