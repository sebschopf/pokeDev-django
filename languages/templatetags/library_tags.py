# languages/templatetags/library_tags.py
from django import template
from django.db.models import Q
from ..models.library import Libraries, LibraryLanguages
from ..models.technology_categories import get_category_for_technology_type

try:
    from ..config.display_names import get_display_name
except ImportError:
    # Fallback si le module n'est pas trouvé
    def get_display_name(slug, default_name):
        return default_name

register = template.Library()

@register.filter
def display_library_name(library):
    """
    Filtre pour afficher un nom plus lisible pour certaines bibliothèques
    """
    if not library:
        return ""
    return get_display_name(library.slug, library.name)

@register.inclusion_tag('languages/detail_outil_associe.html')
def show_associated_tools(language):
    """
    Tag de template pour afficher les outils associés à un langage.
    
    Usage:
    {% load library_tags %}
    {% show_associated_tools language %}
    """
    # Récupérer les bibliothèques associées via la table de jonction
    library_ids = LibraryLanguages.objects.filter(
        language_id=language.id
    ).values_list('library_id', flat=True)
    libraries_from_junction = Libraries.objects.filter(id__in=library_ids)

    # Bibliothèques liées directement via le champ ForeignKey
    libraries_from_fk = Libraries.objects.filter(language=language)

    # Combiner les deux ensembles de bibliothèques (en évitant les doublons)
    all_libraries = Libraries.objects.filter(
        Q(id__in=libraries_from_junction) | Q(language=language)
    ).distinct()
    
    # Créer une structure de données pour les catégories avec leurs bibliothèques
    categories_data = []
    uncategorized_libraries = []
    
    # Classer chaque bibliothèque dans sa catégorie
    for library in all_libraries:
        # Obtenir la catégorie pour ce type de technologie
        category_info = get_category_for_technology_type(library.technology_type)
        
        if category_info:
            # Trouver la catégorie existante ou en créer une nouvelle
            category_found = False
            for category in categories_data:
                if category['key'] == category_info['key']:
                    category['libraries'].append(library)
                    category_found = True
                    break
            
            if not category_found:
                # Créer une nouvelle catégorie avec cette bibliothèque
                category_data = category_info.copy()
                category_data['libraries'] = [library]
                categories_data.append(category_data)
        else:
            # Si aucune catégorie ne correspond, ajouter à non catégorisé
            uncategorized_libraries.append(library)
    
    # Trier les bibliothèques par nom dans chaque catégorie
    for category in categories_data:
        category['libraries'].sort(key=lambda x: x.name)
    
    # Ajouter les bibliothèques non catégorisées si elles existent
    if uncategorized_libraries:
        categories_data.append({
            'key': 'uncategorized',
            'title': 'AUTRES OUTILS',
            'libraries': sorted(uncategorized_libraries, key=lambda x: x.name),
            'default_desc': 'Outil pour',
            'icon': 'help-circle'
        })
    
    # Retourner le contexte pour le template
    return {
        'categories_data': categories_data,
        'language': language,
        'debug_info': {
            'total_libraries': all_libraries.count(),
            'technology_types': list(all_libraries.values_list('technology_type', flat=True).distinct())
        }
    }
