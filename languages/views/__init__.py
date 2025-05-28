# Import des vues principales pour les rendre disponibles
from .api_views import get_field_value  # Importation de la vue API
from .corrections_views import propose_correction, correction_list, correction_detail  # Importation des vues de corrections
from .docs_views import accessibility_methodology  # Importation de la vue de méthodologie d'accessibilité
from .framework_views import framework_detail  # Importation depuis le bon fichier
from .language_views import list, LanguageDetailView, LanguageListView  # Importation des vues de liste et de détail des langages
from .search_views import advanced_search  # Importation de la vue de recherche avancée
from .mobile_menu_views import mobile_menu_partial, mobile_menu_partial_json  # Importation de la vue pour le menu mobile


__all__ = [
    'get_field_value',
    'propose_correction',
    'correction_list',
    'correction_detail',
    'accessibility_methodology',
    'framework_detail',
    'list',
    'LanguageDetailView',
    'LanguageListView',
    'advanced_search',
    'mobile_menu_partial',  
    'mobile_menu_partial_json',
]
