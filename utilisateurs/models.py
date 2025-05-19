# Ce fichier sert de point d'entrée pour tous les modèles de l'application utilisateurs
# Il importe et expose les modèles depuis les sous-modules

# Importer les modèles depuis le package models
from .models.profile import Profile, UserRole
from .models.language_expertise import LanguageExpertise
from .models.comment import CorrectionComment

# Exposer les classes au niveau du package pour faciliter l'importation
__all__ = ['Profile', 'UserRole', 'LanguageExpertise', 'CorrectionComment']
