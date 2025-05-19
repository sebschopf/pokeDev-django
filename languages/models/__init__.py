# Importer les modèles pour les rendre disponibles via languages.models
from .language import Languages, Corrections, LanguageProposals, LanguagesFramework
from .library import Libraries, LibraryLanguages
from .technology import TechnologyCategories, TechnologySubtypes
from .usage import UsageCategories, LanguageUsage

# Exposer les classes au niveau du package
__all__ = [
    'Languages', 'Corrections', 'LanguageProposals', 'LanguagesFramework',
    'Libraries', 'LibraryLanguages',
    'TechnologyCategories', 'TechnologySubtypes',
    'UsageCategories', 'LanguageUsage'
]
