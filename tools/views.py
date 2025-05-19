from django.shortcuts import render
from django.http import HttpResponse
from django.db import connection

def test_view(request):
    """
    Vue de test simple pour vérifier si l'URL fonctionne.
    """
    return HttpResponse("La vue de test fonctionne!")

def tool_detail(request, slug):
    """
    Affiche les détails d'un outil spécifique.
    """
    try:
        # Récupérer l'outil directement depuis la base de données
        with connection.cursor() as cursor:
            # Récupérer les détails de l'outil
            cursor.execute("""
                SELECT * FROM libraries WHERE slug = %s
            """, [slug])
            tool = cursor.fetchone()
            
            if not tool:
                return HttpResponse(f"Outil non trouvé avec le slug: {slug}")
            
            # Récupérer les noms des colonnes
            columns = [col[0] for col in cursor.description]
            
            # Convertir en dictionnaire
            tool_dict = dict(zip(columns, tool))
            
            # Récupérer le langage principal associé
            cursor.execute("""
                SELECT * FROM languages WHERE id = %s
            """, [tool_dict['language_id']])
            primary_language = cursor.fetchone()
            
            if primary_language:
                language_columns = [col[0] for col in cursor.description]
                primary_language_dict = dict(zip(language_columns, primary_language))
            else:
                primary_language_dict = None
            
            # Récupérer tous les langages associés via la table de jonction
            cursor.execute("""
                SELECT l.* FROM languages l
                JOIN library_languages ll ON l.id = ll.language_id
                WHERE ll.library_id = %s
            """, [tool_dict['id']])
            
            associated_languages = []
            for language in cursor.fetchall():
                language_columns = [col[0] for col in cursor.description]
                language_dict = dict(zip(language_columns, language))
                associated_languages.append(language_dict)
            
            # Si le langage principal n'est pas dans la liste des langages associés, l'ajouter
            if primary_language_dict:
                primary_language_id = primary_language_dict['id']
                if not any(lang['id'] == primary_language_id for lang in associated_languages):
                    associated_languages.append(primary_language_dict)
            
            # Récupérer les features si elles existent
            features_list = []
            if tool_dict.get('features'):
                import json
                try:
                    features_list = json.loads(tool_dict['features'])
                except (json.JSONDecodeError, TypeError):
                    pass
        
        # Préparer les données pour le template
        context = {
            'tool': tool_dict,
            'features_list': features_list,
            'language': primary_language_dict,  # Pour la compatibilité avec le template existant
            'associated_languages': associated_languages,  # Tous les langages associés
        }
        
        # Rendre le template
        return render(request, 'tools/detail.html', context)
    
    except Exception as e:
        # En cas d'erreur, afficher un message d'erreur
        return HttpResponse(f"Erreur: {str(e)}")