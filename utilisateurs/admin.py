from django.contrib import admin
from .models import Profile

@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'username', 'full_name', 'created_at')
    search_fields = ('username', 'full_name')
    readonly_fields = ('user_id', 'created_at', 'updated_at')