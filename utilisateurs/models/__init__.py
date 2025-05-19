# Importation des modèles pour les rendre disponibles via utilisateurs.models
from .profile import Profile, UserRole
from .language_expertise import LanguageExpertise
from .comment import CorrectionComment

# Exposer les classes au niveau du package
__all__ = ['Profile', 'UserRole', 'LanguageExpertise', 'CorrectionComment']
