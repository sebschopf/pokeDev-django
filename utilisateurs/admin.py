from django.contrib import admin
from .models import Profile, LanguageExpertise, CorrectionComment

class ProfileAdmin(admin.ModelAdmin):
    list_display = ('username', 'user', 'role', 'created_at', 'updated_at')
    list_filter = ('role', 'created_at')
    search_fields = ('username', 'user__username', 'user__email')
    readonly_fields = ('created_at', 'updated_at')

class LanguageExpertiseAdmin(admin.ModelAdmin):
    list_display = ('user', 'language', 'expertise_level')  # Suppression de 'created_at'
    list_filter = ('expertise_level',)  # Suppression de 'created_at'
    search_fields = ('user__username', 'language__name')

class CorrectionCommentAdmin(admin.ModelAdmin):
    list_display = ('user', 'correction', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('user__username', 'content')
    readonly_fields = ('created_at',)

admin.site.register(Profile, ProfileAdmin)
admin.site.register(LanguageExpertise, LanguageExpertiseAdmin)
admin.site.register(CorrectionComment, CorrectionCommentAdmin)
