# db_docs/management/commands/init_db_docs.py
from django.core.management.base import BaseCommand
from db_docs.models import Chapter, Section

class Command(BaseCommand):
    help = 'Initialise les chapitres et sections de la documentation de la base de données'

    def handle(self, *args, **options):
        # Créer les chapitres
        chapters_data = [
            {
                'title': 'Vue d\'ensemble',
                'slug': 'overview',
                'order': 1,
                'description': 'Vue d\'ensemble de la structure de la base de données',
                'sections': [
                    {
                        'title': 'Introduction',
                        'content': '<p>Cette documentation fournit une vue complète de la structure de la base de données utilisée dans ce projet.</p>',
                        'order': 1,
                    },
                    {
                        'title': 'Architecture',
                        'content': '<p>La base de données est organisée en plusieurs schémas qui séparent les différentes fonctionnalités de l\'application.</p>',
                        'order': 2,
                    },
                ]
            },
            {
                'title': 'Schémas',
                'slug': 'schemas',
                'order': 2,
                'description': 'Informations sur les schémas de la base de données',
                'sections': [
                    {
                        'title': 'Qu\'est-ce qu\'un schéma?',
                        'content': '<p>Un schéma est un conteneur qui permet d\'organiser les objets de la base de données (tables, vues, etc.) en groupes logiques.</p>',
                        'order': 1,
                        'sql_example': 'SELECT schema_name FROM information_schema.schemata;',
                    },
                ]
            },
            {
                'title': 'Tables',
                'slug': 'tables',
                'order': 3,
                'description': 'Informations sur les tables de la base de données',
                'sections': [
                    {
                        'title': 'Structure des tables',
                        'content': '<p>Les tables sont les objets principaux de la base de données qui stockent les données.</p>',
                        'order': 1,
                        'sql_example': 'SELECT table_name FROM information_schema.tables WHERE table_schema = \'public\';',
                    },
                ]
            },
            # Ajoutez d'autres chapitres ici
        ]
        
        self.stdout.write('Initialisation des chapitres et sections...')
        
        for chapter_data in chapters_data:
            sections_data = chapter_data.pop('sections', [])
            chapter, created = Chapter.objects.update_or_create(
                slug=chapter_data['slug'],
                defaults=chapter_data
            )
            
            for section_data in sections_data:
                Section.objects.update_or_create(
                    chapter=chapter,
                    title=section_data['title'],
                    defaults=section_data
                )
        
        self.stdout.write(self.style.SUCCESS('Documentation initialisée avec succès!'))