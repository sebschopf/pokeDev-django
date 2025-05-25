from django.core.management.base import BaseCommand
from seo.utils import ping_search_engines

class Command(BaseCommand):
    help = 'Met à jour le sitemap et notifie les moteurs de recherche'

    def handle(self, *args, **options):
        self.stdout.write('Notification des moteurs de recherche...')
        ping_search_engines()
        self.stdout.write(
            self.style.SUCCESS('Sitemap mis à jour avec succès!')
        )
        self.stdout.write(
            self.style.SUCCESS('Moteurs de recherche notifiés avec succès!')
        )