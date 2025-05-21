# Checklist de déploiement sur Railway

## Avant le déploiement
- [x] Configuration Django validée (check_config.py)
- [ ] Connexion à la base de données vérifiée (check_db.py)
- [ ] Fichiers statiques collectés (collectstatic)
- [ ] Fonctionnalités principales testées manuellement
- [ ] Variables d'environnement configurées sur Railway:
  - [ ] SECRET_KEY
  - [ ] DATABASE_URL
  - [ ] DEBUG=False
  - [ ] ALLOWED_HOSTS
  - [ ] RUNNING_ON_RAILWAY=True

## Procédure de déploiement
1. Commit des dernières modifications:
   \`\`\`
   git add .
   git commit -m "Préparation pour déploiement"
   \`\`\`

2. Pousser vers le dépôt connecté à Railway:
   \`\`\`
   git push origin main
   \`\`\`

3. Vérifier le déploiement sur le tableau de bord Railway

## Après le déploiement
- [ ] Vérifier que le site est accessible
- [ ] Vérifier que les pages principales fonctionnent
- [ ] Vérifier que les fichiers statiques sont correctement servis
- [ ] Vérifier les logs pour détecter d'éventuelles erreurs
