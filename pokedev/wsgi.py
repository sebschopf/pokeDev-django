

import os

from django.core.wsgi import get_wsgi_application
from dotenv import load_dotenv

# Chargement des variables d'environnement depuis le fichier .env
load_dotenv

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'pokedev.settings')

application = get_wsgi_application()
