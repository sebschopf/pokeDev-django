from django.shortcuts import render

def error_view(request, error_message=None, error_details=None):
    """
    Vue générique pour afficher les erreurs.
    """
    if error_message is None:
        error_message = "Une erreur inattendue s'est produite."
    
    context = {
        'error_message': error_message,
        'error_details': error_details,
        'nom_de_la_page': "Erreur"
    }
    
    return render(request, 'utilisateurs/error.html', context)
