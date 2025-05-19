from django.core.management.base import BaseCommand
from languages.models import Languages
import re

class Command(BaseCommand):
    help = 'Vérifie le contenu des SVG dans la base de données'

    def handle(self, *args, **options):
        languages = Languages.objects.all()
        self.stdout.write(f"Vérification des SVG pour {languages.count()} langages")
        
        for language in languages:
            self.stdout.write(f"\n{language.name}:")
            
            if hasattr(language, 'logo_svg') and language.logo_svg:
                # Vérifier si le contenu commence par <svg
                if re.match(r'^\s*<svg', language.logo_svg):
                    self.stdout.write(self.style.SUCCESS(f"  ✓ SVG valide (commence par <svg)"))
                    # Afficher les 50 premiers caractères
                    self.stdout.write(f"  Aperçu: {language.logo_svg[:50]}...")
                    # Vérifier la taille du SVG
                    self.stdout.write(f"  Taille: {len(language.logo_svg)} caractères")
                else:
                    self.stdout.write(self.style.ERROR(f"  ✗ SVG invalide (ne commence pas par <svg)"))
                    self.stdout.write(f"  Contenu: {language.logo_svg[:100]}...")
            else:
                self.stdout.write(self.style.WARNING(f"  ⚠ Pas de SVG défini"))
