from django.contrib import admin
from ..models import TechnologyCategories, TechnologySubtypes

class TechnologyCategoriesAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'description')
    search_fields = ('name', 'description')
    list_filter = ('created_at',)

class TechnologySubtypesAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'created_at')
    list_filter = ('category',)
    search_fields = ('name',)

    def category(self, obj):
        if obj.category_id and hasattr(obj, 'category') and obj.category:
            return obj.category.name
        return "-"
    category.short_description = "Catégorie"
