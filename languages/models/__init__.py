# Importer les modèles pour les rendre disponibles via languages.models
from .language import Languages
from .framework import LanguagesFramework
from .library import Libraries, LibraryLanguages
from .technology import TechnologyCategories, TechnologySubtypes
from .usage import UsageCategories, LanguageUsage
from .corrections import Corrections
from .language_proposals import LanguageProposals
from .accessibility import AccessibilityLevels, AccessibilityCriteria, LanguageAccessibilityLevels, LanguageAccessibilityEvaluations
from .features import LanguageFeatures, LanguageFeatureValues

# Exposer les classes au niveau du package
__all__ = [
    'Languages', 'Corrections', 'LanguageProposals', 'LanguagesFramework',
    'Libraries', 'LibraryLanguages',
    'TechnologyCategories', 'TechnologySubtypes',
    'UsageCategories', 'LanguageUsage',
    'AccessibilityLevels', 'AccessibilityCriteria', 
    'LanguageAccessibilityLevels', 'LanguageAccessibilityEvaluations',
    'LanguageFeatures', 'LanguageFeatureValues',
]