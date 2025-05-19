from django.core.management.base import BaseCommand
from django.db import connection

class Command(BaseCommand):
    help = 'Exécute une requête SQL pour vérifier les données SVG dans la table languages'

    def handle(self, *args, **options):
        with connection.cursor() as cursor:
            # Vérifier la structure de la table
            cursor.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'languages'")
            columns = cursor.fetchall()
            self.stdout.write("Structure de la table languages:")
            for column in columns:
                self.stdout.write(f"  {column[0]}: {column[1]}")
            
            # Vérifier si la colonne logo_svg existe
            logo_svg_exists = any(column[0] == 'logo_svg' for column in columns)
            if not logo_svg_exists:
                self.stdout.write(self.style.ERROR("La colonne logo_svg n'existe pas dans la table!"))
                return
            
            # Vérifier les données SVG
            cursor.execute("SELECT id, name, length(logo_svg) as svg_length FROM languages ORDER BY name")
            rows = cursor.fetchall()
            
            self.stdout.write("\nContenu de la colonne logo_svg:")
            for row in rows:
                id, name, svg_length = row
                if svg_length and svg_length > 0:
                    self.stdout.write(self.style.SUCCESS(f"  {name} (ID: {id}): {svg_length} caractères"))
                    
                    # Afficher un extrait du SVG
                    cursor.execute("SELECT substring(logo_svg from 1 for 100) FROM languages WHERE id = %s", [id])
                    svg_preview = cursor.fetchone()[0]
                    self.stdout.write(f"    Aperçu: {svg_preview}...")
                else:
                    self.stdout.write(self.style.WARNING(f"  {name} (ID: {id}): Vide ou NULL"))
            
            # Compter les entrées avec et sans SVG
            cursor.execute("SELECT COUNT(*) FROM languages WHERE logo_svg IS NOT NULL AND length(logo_svg) > 0")
            with_svg = cursor.fetchone()[0]
            
            cursor.execute("SELECT COUNT(*) FROM languages WHERE logo_svg IS NULL OR length(logo_svg) = 0")
            without_svg = cursor.fetchone()[0]
            
            self.stdout.write(f"\nRésumé: {with_svg} langages avec SVG, {without_svg} langages sans SVG")
