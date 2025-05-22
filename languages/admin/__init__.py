# languages/admin/__init__.py
from django.contrib import admin
from .language_admin import LanguagesAdmin
from .corrections_admin import CorrectionsAdmin
from .library_admin import LibrariesAdmin, LibraryLanguagesAdmin
from .proposal_admin import LanguageProposalsAdmin
from .technology_admin import TechnologyCategoriesAdmin, TechnologySubtypesAdmin
from .accessibility_admin import AccessibilityLevelsAdmin, AccessibilityCriteriaAdmin, LanguageAccessibilityLevelsAdmin, LanguageAccessibilityEvaluationsAdmin
from ..models import (
    Languages, Corrections, LanguageProposals, LanguagesFramework,
    Libraries, LibraryLanguages,
    TechnologyCategories, TechnologySubtypes,
    UsageCategories, LanguageUsage,
    AccessibilityLevels, AccessibilityCriteria, 
    LanguageAccessibilityLevels, LanguageAccessibilityEvaluations
)

# Enregistrer les modèles avec leurs classes d'administration
admin.site.register(Languages, LanguagesAdmin)
admin.site.register(Corrections, CorrectionsAdmin)
admin.site.register(Libraries, LibrariesAdmin)
admin.site.register(LibraryLanguages, LibraryLanguagesAdmin)
admin.site.register(LanguageProposals, LanguageProposalsAdmin)
admin.site.register(TechnologyCategories, TechnologyCategoriesAdmin)
admin.site.register(TechnologySubtypes, TechnologySubtypesAdmin)
admin.site.register(AccessibilityLevels, AccessibilityLevelsAdmin)
admin.site.register(AccessibilityCriteria, AccessibilityCriteriaAdmin)
admin.site.register(LanguageAccessibilityLevels, LanguageAccessibilityLevelsAdmin)
admin.site.register(LanguageAccessibilityEvaluations, LanguageAccessibilityEvaluationsAdmin)

# Enregistrer les autres modèles avec l'administration par défaut
admin.site.register(LanguagesFramework)
admin.site.register(UsageCategories)
admin.site.register(LanguageUsage)