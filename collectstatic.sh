#!/bin/bash
# Script pour collecter les fichiers statiques et les placer au bon endroit

# Créer les répertoires nécessaires s'ils n'existent pas
mkdir -p languages/static/admin/css
mkdir -p languages/static/admin/js

# Exécuter collectstatic
python manage.py collectstatic --noinput

# Vérifier que les fichiers existent
echo "Vérification des fichiers statiques..."
if [ -f "languages/static/admin/css/custom_admin.css" ]; then
    echo "✓ Le fichier CSS existe"
else
    echo "✗ Le fichier CSS n'existe pas"
fi

if [ -f "languages/static/admin/js/svg_preview.js" ]; then
    echo "✓ Le fichier JS existe"
else
    echo "✗ Le fichier JS n'existe pas"
fi

echo "Terminé!"
