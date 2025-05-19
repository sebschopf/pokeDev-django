from django.core.management.base import BaseCommand
from languages.models import Languages
import re

class Command(BaseCommand):
    help = 'Vérifie et corrige les attributs de couleur dans les SVG'

    def handle(self, *args, **options):
        languages = Languages.objects.exclude(logo_svg__isnull=True).exclude(logo_svg='')
        self.stdout.write(f"Vérification des couleurs SVG pour {languages.count()} langages...")
        
        fixed_count = 0
        for language in languages:
            if not language.logo_svg:
                continue
                
            original_svg = language.logo_svg
            
            # Vérifier si le SVG contient déjà des attributs de couleur
            has_fill = re.search(r'fill="[^"]+"', original_svg) is not None
            has_stroke = re.search(r'stroke="[^"]+"', original_svg) is not None
            
            if has_fill and has_stroke:
                self.stdout.write(f"  {language.name}: Le SVG a déjà des attributs de couleur")
                continue
                
            # Si le SVG n'a pas d'attributs de couleur, ajouter des couleurs par défaut
            # aux éléments path, circle, rect, etc.
            modified_svg = original_svg
            
            # Ajouter fill aux éléments sans attribut fill
            if not has_fill:
                # Ajouter fill aux éléments path, circle, rect, etc. qui n'ont pas déjà un attribut fill
                for tag in ['path', 'circle', 'rect', 'polygon', 'ellipse']:
                    pattern = rf'<{tag}([^>]*?)(/?)>'
                    replacement = self._add_fill_if_missing
                    modified_svg = re.sub(pattern, replacement, modified_svg)
            
            # Si le SVG a été modifié, le sauvegarder
            if modified_svg != original_svg:
                language.logo_svg = modified_svg
                language.save()
                fixed_count += 1
                self.stdout.write(self.style.SUCCESS(f"  {language.name}: SVG corrigé"))
            else:
                self.stdout.write(f"  {language.name}: Aucune modification nécessaire")
        
        self.stdout.write(self.style.SUCCESS(f"Terminé. {fixed_count} SVG ont été corrigés."))
    
    def _add_fill_if_missing(self, match):
        tag_content = match.group(1)
        closing = match.group(2)
        
        # Vérifier si l'élément a déjà un attribut fill
        if 'fill=' in tag_content:
            return f"<{match.group(0)[1:]}"
        
        # Ajouter l'attribut fill
        return f"<{match.group(0)[1:-len(closing)-1]} fill=\"currentColor\"{closing}>"
