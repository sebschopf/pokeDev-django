# Checklist de déploiement PokeDev

## Vérifications de base
- [ ] La syntaxe Python est valide (`python -m compileall .`)
- [ ] Aucune erreur avec `python manage.py check`
- [ ] Les fichiers statiques sont collectés (`python manage.py collectstatic --noinput`)
- [ ] Les variables d'environnement sont configurées

## Test manuel des fonctionnalités principales
- [ ] La page d'accueil se charge correctement
- [ ] La liste des langages s'affiche
- [ ] Les détails d'un langage s'affichent
- [ ] Les bibliothèques associées aux langages sont visibles
- [ ] La connexion utilisateur fonctionne
- [ ] Les formulaires de soumission fonctionnent

## Vérifications de sécurité
- [ ] DEBUG est désactivé en production
- [ ] Les clés secrètes sont sécurisées
- [ ] ALLOWED_HOSTS est correctement configuré
- [ ] Les en-têtes de sécurité sont activés
