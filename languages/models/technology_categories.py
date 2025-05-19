# languages/models/technology_categories.py

# Mapping des types de technologie vers des catégories logiques
TECHNOLOGY_CATEGORY_MAPPING = {
    'frameworks': {
        'title': 'FRAMEWORKS',
        'types': ['Framework'],
        'default_desc': 'Framework pour',
        'icon': 'grid'  # Nom d'une icône (optionnel)
    },
    'libraries': {
        'title': 'BIBLIOTHÈQUES',
        'types': ['Bibliothèque', 'Bibliothèque scientifique', 'Bibliothèque de données', 
                 'Bibliothèque de visualisation', 'Bibliothèque spécialisée'],
        'default_desc': 'Bibliothèque pour',
        'icon': 'book'
    },
    'development_tools': {
        'title': 'OUTILS DE DÉVELOPPEMENT',
        'types': ['Outil', 'testing-tool', 'Environnement de développement', 'SDK', 
                 'Toolkit', 'Générateur', 'Compilateur/Transpileur'],
        'default_desc': 'Outil pour',
        'icon': 'tool'
    },
    'engines': {
        'title': 'MOTEURS ET RUNTIMES',
        'types': ['Moteur', 'Runtime', 'Environnement de simulation'],
        'default_desc': 'Moteur pour',
        'icon': 'cpu'
    },
    'apis_and_communication': {
        'title': 'APIs ET COMMUNICATION',
        'types': ['API', 'Communication', 'Binding', 'Sérialisation'],
        'default_desc': 'API pour',
        'icon': 'link'
    },
    'platforms_and_systems': {
        'title': 'PLATEFORMES ET SYSTÈMES',
        'types': ['Plateforme', 'Système de design', 'Système d\'exploitation', 
                 'Système de programmation', 'CMS', 'Serveur'],
        'default_desc': 'Plateforme pour',
        'icon': 'layers'
    },
    'language_extensions': {
        'title': 'EXTENSIONS DE LANGAGE',
        'types': ['Extension de langage', 'Langage de script', 'Implémentation de langage', 'ORM'],
        'default_desc': 'Extension pour',
        'icon': 'code'
    }
}

def get_category_for_technology_type(technology_type):
    """
    Retourne la catégorie correspondant à un type de technologie donné.
    
    Args:
        technology_type (str): Le type de technologie à catégoriser
        
    Returns:
        dict or None: Les informations de la catégorie ou None si aucune correspondance
    """
    for category_key, category_info in TECHNOLOGY_CATEGORY_MAPPING.items():
        if technology_type in category_info['types']:
            return {
                'key': category_key,
                'title': category_info['title'],
                'default_desc': category_info['default_desc'],
                'icon': category_info.get('icon')
            }
    return None

def get_all_categories():
    """
    Retourne toutes les catégories définies.
    
    Returns:
        list: Liste de toutes les catégories avec leurs informations
    """
    return [
        {
            'key': key,
            'title': info['title'],
            'default_desc': info['default_desc'],
            'icon': info.get('icon'),
            'types': info['types']
        }
        for key, info in TECHNOLOGY_CATEGORY_MAPPING.items()
    ]
