from django.core.management.base import BaseCommand
from seo.models import SEOConfig

class Command(BaseCommand):
    help = 'Initialise la configuration SEO par défaut'

    def handle(self, *args, **options):
        config, created = SEOConfig.objects.get_or_create(
            defaults={
                'site_name': 'PokeDev',
                'site_description': 'Cartes interactives des langages de programmation et de leurs outils',
                'default_keywords': 'programmation, langages, frameworks, développement, code, tutoriels',
                'twitter_handle': '@pokedev'
            }
        )
        
        if created:
            self.stdout.write(
                self.style.SUCCESS('✅ Configuration SEO créée avec succès!')
            )
        else:
            self.stdout.write(
                self.style.WARNING('⚠️ Configuration SEO existe déjà.')
            )
