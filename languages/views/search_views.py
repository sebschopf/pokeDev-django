from django.shortcuts import render
from django.db.models import Q
from ..models import Languages, LanguageFeatures, LanguageFeatureValues

def advanced_search(request):
    # Récupérer toutes les caractéristiques pour le formulaire
    features = LanguageFeatures.objects.all().order_by('feature_type', 'display_order')
    
    # Initialiser les paramètres et les résultats
    params = {}
    results = None
    
    # Si le formulaire a été soumis
    if request.GET:
        # Construire la requête de base
        query = Languages.objects.all()
        
        # Filtrer par nom
        name = request.GET.get('name', '')
        if name:
            query = query.filter(name__icontains=name)
            params['name'] = name
        
        # Filtrer par type
        type_filter = request.GET.get('type', '')
        if type_filter:
            query = query.filter(type__icontains=type_filter)
            params['type'] = type_filter
        
        # Filtrer par année de création (min)
        year_min = request.GET.get('year_min', '')
        if year_min and year_min.isdigit():
            query = query.filter(year_created__gte=int(year_min))
            params['year_min'] = year_min
        
        # Filtrer par année de création (max)
        year_max = request.GET.get('year_max', '')
        if year_max and year_max.isdigit():
            query = query.filter(year_created__lte=int(year_max))
            params['year_max'] = year_max
        
        # Filtrer par caractéristiques
        for key, value in request.GET.items():
            if key.startswith('feature_') and value:
                feature_id = key.replace('feature_', '')
                if feature_id.isdigit():
                    # Récupérer la caractéristique
                    try:
                        feature = LanguageFeatures.objects.get(id=int(feature_id))
                        
                        # Filtrer selon le type de caractéristique
                        if feature.is_boolean:
                            # Pour les caractéristiques booléennes
                            if value == 'Oui':
                                query = query.filter(
                                    languagefeaturevalues__feature_id=feature_id,
                                    languagefeaturevalues__value__iexact='Oui'
                                )
                            elif value == 'Non':
                                query = query.filter(
                                    languagefeaturevalues__feature_id=feature_id,
                                    languagefeaturevalues__value__iexact='Non'
                                )
                        else:
                            # Pour les caractéristiques textuelles
                            query = query.filter(
                                languagefeaturevalues__feature_id=feature_id,
                                languagefeaturevalues__value__icontains=value
                            )
                        
                        params[f'feature_{feature_id}'] = value
                    except LanguageFeatures.DoesNotExist:
                        pass
        
        # Exécuter la requête
        results = query.distinct()
    
    return render(request, 'languages/advanced_search.html', {
        'features': features,
        'params': params,
        'results': results
    })