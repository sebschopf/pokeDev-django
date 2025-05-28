from django.contrib import admin
from .models import Tool, TechnologyCategory, TechnologySubtype


admin.site.register(Tool)
admin.site.register(TechnologyCategory)
admin.site.register(TechnologySubtype)