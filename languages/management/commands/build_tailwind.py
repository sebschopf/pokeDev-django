from django.core.management.base import BaseCommand
import subprocess
import os
import sys

class Command(BaseCommand):
    help = 'Compile les fichiers CSS Tailwind pour la production'

    def handle(self, *args, **options):
        try:
            self.stdout.write('Compilation des fichiers CSS Tailwind...')
            
            # Déterminer le chemin complet de npm
            npm_cmd = 'npm'
            if sys.platform == 'win32':
                # Sur Windows, essayer de trouver npm dans les emplacements courants
                possible_paths = [
                    os.path.join(os.environ.get('APPDATA', ''), 'npm', 'npm.cmd'),
                    os.path.join(os.environ.get('ProgramFiles', ''), 'nodejs', 'npm.cmd'),
                    os.path.join(os.environ.get('ProgramFiles(x86)', ''), 'nodejs', 'npm.cmd'),
                ]
                for path in possible_paths:
                    if os.path.exists(path):
                        npm_cmd = path
                        break
            
            self.stdout.write(f'Utilisation de npm: {npm_cmd}')
            
            # Vérifier si Node.js est installé
            try:
                subprocess.run(['node', '--version'], check=True, capture_output=True, shell=True)
                self.stdout.write('Node.js est installé')
            except (subprocess.CalledProcessError, FileNotFoundError) as e:
                self.stdout.write(self.style.ERROR(f'Node.js n\'est pas installé ou n\'est pas dans le PATH. Erreur: {e}'))
                return
            
            # Installer les dépendances si elles ne sont pas déjà installées
            if not os.path.exists('node_modules'):
                self.stdout.write('Installation des dépendances...')
                subprocess.run([npm_cmd, 'install'], check=True, shell=True)
            
            # Compiler Tailwind CSS
            self.stdout.write('Compilation de Tailwind CSS...')
            result = subprocess.run([npm_cmd, 'run', 'build'], capture_output=True, text=True, shell=True)
            
            if result.returncode == 0:
                self.stdout.write(self.style.SUCCESS('Compilation terminée avec succès !'))
                self.stdout.write(result.stdout)
            else:
                self.stdout.write(self.style.ERROR(f'Erreur lors de la compilation :'))
                self.stdout.write(result.stderr)
            
        except subprocess.CalledProcessError as e:
            self.stdout.write(self.style.ERROR(f'Erreur lors de la compilation : {e}'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Erreur inattendue : {e}'))
