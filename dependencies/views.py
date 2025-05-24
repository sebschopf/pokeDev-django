from django.shortcuts import render

def tribute_view(request):
    """Vue pour afficher l'hommage aux contributeurs open source"""
    
    dependencies = [
        {
            'name': 'Django',
            'version': '5.2.1',
            'description': 'Framework web Python de haut niveau',
            'maintainers': [
                {
                    'name': 'Adrian Holovaty',
                    'github': 'https://github.com/adrianholovaty',
                    'website': 'http://www.holovaty.com/'
                },
                {
                    'name': 'Simon Willison',
                    'github': 'https://github.com/simonw',
                    'website': 'https://simonwillison.net/'
                },
                {
                    'name': 'Jacob Kaplan-Moss',
                    'github': 'https://github.com/jacobian',
                    'website': 'https://jacobian.org/'
                }
            ],
            'current_lead': 'Django Software Foundation',
            'github': 'https://github.com/django/django',
            'website': 'https://djangoproject.com',
            'license': 'BSD-3-Clause',
            'category': 'Framework Web'
        },
        {
            'name': 'PostgreSQL (psycopg2)',
            'version': '2.9.10',
            'description': 'Adaptateur PostgreSQL pour Python',
            'maintainers': [
                {
                    'name': 'Federico Di Gregorio',
                    'github': 'https://github.com/fogzot',
                    'website': None
                },
                {
                    'name': 'Daniele Varrazzo',
                    'github': 'https://github.com/dvarrazzo',
                    'website': 'https://www.varrazzo.com/'
                }
            ],
            'current_lead': 'The Psycopg Team',
            'github': 'https://github.com/psycopg/psycopg2',
            'website': 'https://psycopg.org',
            'license': 'LGPL-3.0',
            'category': 'Base de données'
        },
        {
            'name': 'Gunicorn',
            'version': '23.0.0',
            'description': 'Serveur WSGI HTTP Python pour UNIX',
            'maintainers': [
                {
                    'name': 'Benoit Chesneau',
                    'github': 'https://github.com/benoitc',
                    'website': 'https://benoitc.io/'
                }
            ],
            'current_lead': 'Gunicorn Team',
            'github': 'https://github.com/benoitc/gunicorn',
            'website': 'https://gunicorn.org',
            'license': 'MIT',
            'category': 'Serveur'
        },
        {
            'name': 'Pillow',
            'version': 'Latest',
            'description': 'Bibliothèque de traitement d\'images Python',
            'maintainers': [
                {
                    'name': 'Alex Clark',
                    'github': 'https://github.com/aclark4life',
                    'website': 'https://blog.aclark.net/'
                },
                {
                    'name': 'Hugo van Kemenade',
                    'github': 'https://github.com/hugovk',
                    'website': 'https://hugovk.github.io/'
                }
            ],
            'current_lead': 'Pillow Team',
            'github': 'https://github.com/python-pillow/Pillow',
            'website': 'https://pillow.readthedocs.io',
            'license': 'PIL Software License',
            'category': 'Traitement d\'images'
        },
        {
            'name': 'Requests',
            'version': '2.32.3',
            'description': 'Bibliothèque HTTP élégante et simple',
            'maintainers': [
                {
                    'name': 'Kenneth Reitz',
                    'github': 'https://github.com/kennethreitz',
                    'website': 'https://kennethreitz.org/'
                }
            ],
            'current_lead': 'Python Software Foundation',
            'github': 'https://github.com/psf/requests',
            'website': 'https://requests.readthedocs.io',
            'license': 'Apache-2.0',
            'category': 'HTTP Client'
        },
        {
            'name': 'WhiteNoise',
            'version': '6.9.0',
            'description': 'Middleware pour servir des fichiers statiques',
            'maintainers': [
                {
                    'name': 'David Evans',
                    'github': 'https://github.com/evansd',
                    'website': 'http://whitenoise.evans.io'
                }
            ],
            'current_lead': 'David Evans',
            'github': 'https://github.com/evansd/whitenoise',
            'website': 'http://whitenoise.evans.io',
            'license': 'MIT',
            'category': 'Middleware'
        },
        {
            'name': 'python-dotenv',
            'version': '1.0.0',
            'description': 'Charge les variables d\'environnement depuis .env',
            'maintainers': [
                {
                    'name': 'Saurabh Kumar',
                    'github': 'https://github.com/theskumar',
                    'website': 'https://saurabh-kumar.com/'
                }
            ],
            'current_lead': 'Saurabh Kumar',
            'github': 'https://github.com/theskumar/python-dotenv',
            'website': 'https://saurabh-kumar.com/python-dotenv',
            'license': 'BSD-3-Clause',
            'category': 'Configuration'
        },
        {
            'name': 'dj-database-url',
            'version': '2.3.0',
            'description': 'Utilise les URLs de base de données dans Django',
            'maintainers': [
                {
                    'name': 'Kenneth Reitz',
                    'github': 'https://github.com/kennethreitz',
                    'website': 'https://kennethreitz.org/'
                },
                {
                    'name': 'Jacobian',
                    'github': 'https://github.com/jacobian',
                    'website': 'https://jacobian.org/'
                }
            ],
            'current_lead': 'Jacobian',
            'github': 'https://github.com/jazzband/dj-database-url',
            'website': 'https://github.com/jazzband/dj-database-url',
            'license': 'BSD-2-Clause',
            'category': 'Configuration'
        }
    ]
    
    # Grouper par catégorie
    categories = {}
    for dep in dependencies:
        category = dep['category']
        if category not in categories:
            categories[category] = []
        categories[category].append(dep)
    
    context = {
        'dependencies': dependencies,
        'categories': categories,
        'total_dependencies': len(dependencies)
    }
    
    return render(request, 'dependencies/tribute.html', context)
