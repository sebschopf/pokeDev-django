from django.conf import settings
from django.urls import reverse
from .models import SEOConfig, SEOMetadata
import json

class SEOGenerator:
    """Générateur automatique de métadonnées SEO"""
    
    def __init__(self, obj, request=None):
        self.obj = obj
        self.request = request
        self.config = SEOConfig.objects.first()
        
        # Essayer de récupérer les métadonnées personnalisées
        try:
            self.custom_meta = SEOMetadata.objects.get(
                content_type__model=obj._meta.model_name,
                object_id=obj.pk
            )
        except SEOMetadata.DoesNotExist:
            self.custom_meta = None
    
    def get_title(self):
        """Génère le titre de la page"""
        if self.custom_meta and self.custom_meta.custom_title:
            return self.custom_meta.custom_title
        
        # Logique spécifique par type d'objet
        if hasattr(self.obj, 'name'):
            if self.obj._meta.model_name == 'language':
                return f"{self.obj.name} - Langage de programmation | {self.config.site_name}"
            elif self.obj._meta.model_name == 'library':
                return f"{self.obj.name} - {getattr(self.obj, 'technology_type', 'Outil')} | {self.config.site_name}"
        
        return f"{str(self.obj)} | {self.config.site_name}"
    
    def get_description(self):
        """Génère la description"""
        if self.custom_meta and self.custom_meta.custom_description:
            return self.custom_meta.custom_description
        
        if hasattr(self.obj, 'description') and self.obj.description:
            return self.obj.description[:155] + "..." if len(self.obj.description) > 155 else self.obj.description
        
        if hasattr(self.obj, 'short_description') and self.obj.short_description:
            return self.obj.short_description
        
        return self.config.site_description
    
    def get_keywords(self):
        """Génère les mots-clés"""
        if self.custom_meta and self.custom_meta.custom_keywords:
            return self.custom_meta.custom_keywords
        
        keywords = []
        
        # Ajouter le nom de l'objet
        if hasattr(self.obj, 'name'):
            keywords.append(self.obj.name)
        
        # Logique spécifique par type
        if self.obj._meta.model_name == 'language':
            keywords.extend(['programmation', 'langage'])
            if hasattr(self.obj, 'type') and self.obj.type:
                keywords.append(self.obj.type.lower())
            
            # Ajouter les frameworks populaires
            if hasattr(self.obj, 'popular_frameworks') and self.obj.popular_frameworks:
                keywords.extend(self.obj.popular_frameworks[:3])
        
        elif self.obj._meta.model_name == 'library':
            keywords.extend(['bibliothèque', 'framework'])
            if hasattr(self.obj, 'language'):
                keywords.append(self.obj.language.name)
        
        # Ajouter les mots-clés par défaut
        keywords.extend(self.config.default_keywords.split(', '))
        
        return ', '.join(keywords[:10])  # Limiter à 10 mots-clés
    
    def get_robots(self):
        """Génère les directives robots"""
        if self.custom_meta:
            robots = []
            if self.custom_meta.no_index:
                robots.append('noindex')
            else:
                robots.append('index')
            
            if self.custom_meta.no_follow:
                robots.append('nofollow')
            else:
                robots.append('follow')
            
            return ', '.join(robots)
        
        return 'index, follow'
    
    def get_structured_data(self):
        """Génère les données structurées JSON-LD"""
        if self.obj._meta.model_name == 'language':
            return {
                "@context": "https://schema.org",
                "@type": "SoftwareApplication",
                "name": self.obj.name,
                "description": self.get_description(),
                "applicationCategory": "Programming Language",
                "operatingSystem": "Cross-platform",
                "dateCreated": f"{self.obj.year_created}-01-01" if hasattr(self.obj, 'year_created') and self.obj.year_created else None,
                "creator": {
                    "@type": "Organization",
                    "name": self.obj.creator
                } if hasattr(self.obj, 'creator') and self.obj.creator else None,
                "programmingLanguage": self.obj.name,
                "isAccessibleForFree": getattr(self.obj, 'is_open_source', True),
                "url": getattr(self.obj, 'website', None)
            }
        
        elif self.obj._meta.model_name == 'library':
            return {
                "@context": "https://schema.org",
                "@type": "SoftwareApplication",
                "name": self.obj.name,
                "description": self.get_description(),
                "applicationCategory": getattr(self.obj, 'technology_type', 'Software Library'),
                "programmingLanguage": self.obj.language.name if hasattr(self.obj, 'language') else None,
                "isAccessibleForFree": True
            }
        
        # Données par défaut pour le site
        return {
            "@context": "https://schema.org",
            "@type": "WebSite",
            "name": self.config.site_name,
            "description": self.config.site_description,
            "url": self.request.build_absolute_uri('/') if self.request else None
        }
    
    def get_canonical_url(self):
        """Génère l'URL canonique"""
        if self.request:
            return self.request.build_absolute_uri()
        return None
    
    def get_og_image(self):
        """Génère l'image Open Graph"""
        # Chercher une image spécifique à l'objet
        if hasattr(self.obj, 'logo_path') and self.obj.logo_path:
            return self.request.build_absolute_uri(self.obj.logo_path) if self.request else None
        
        # Image par défaut du site
        if self.config.og_image:
            return self.config.og_image
        
        return None

def generate_seo_context(obj, request=None):
    """Fonction utilitaire pour générer tout le contexte SEO"""
    generator = SEOGenerator(obj, request)
    
    return {
        'seo_title': generator.get_title(),
        'seo_description': generator.get_description(),
        'seo_keywords': generator.get_keywords(),
        'seo_robots': generator.get_robots(),
        'seo_canonical': generator.get_canonical_url(),
        'seo_og_image': generator.get_og_image(),
        'seo_structured_data': json.dumps(generator.get_structured_data(), ensure_ascii=False),
    }

# ============================================================================
# = FONCTIONS POUR SITEMAP ET ROBOTS.TXT
# ============================================================================

from django.contrib.sites.models import Site
from django.utils import timezone
from languages.models import Languages

def generate_sitemap_data():
    """Utilitaire pour générer les données du sitemap"""
    try:
        current_site = Site.objects.get_current()
        domain = f"https://{current_site.domain}"
    except:
        # Fallback si pas de site configuré
        domain = "https://pokedev-django-production.up.railway.app"
    
    urls = []
    
    # Page d'accueil
    urls.append({
        'location': domain + '/',
        'lastmod': timezone.now(),
        'changefreq': 'daily',
        'priority': '1.0'
    })
    
    # Page liste des langages
    try:
        urls.append({
            'location': domain + reverse('languages:list'),
            'lastmod': timezone.now(),
            'changefreq': 'daily',
            'priority': '0.9'
        })
    except:
        pass
    
    # Page méthodologie
    try:
        urls.append({
            'location': domain + reverse('languages:accessibility_methodology'),
            'lastmod': timezone.now(),
            'changefreq': 'monthly',
            'priority': '0.7'
        })
    except:
        pass
    
    # Page remerciements
    try:
        urls.append({
            'location': domain + reverse('dependencies:tribute'),
            'lastmod': timezone.now(),
            'changefreq': 'monthly',
            'priority': '0.5'
        })
    except:
        pass
    
    # Pages des langages individuels
    try:
        languages = Languages.objects.all().order_by('name')
        for language in languages:
            urls.append({
                'location': domain + reverse('languages:detail', kwargs={'slug': language.slug}),
                'lastmod': language.updated_at if hasattr(language, 'updated_at') else timezone.now(),
                'changefreq': 'weekly',
                'priority': '0.8'
            })
    except Exception as e:
        print(f"Erreur lors de la génération des URLs de langages: {e}")
    
    return urls

def ping_search_engines():
    """Notifie les moteurs de recherche de la mise à jour du sitemap"""
    import requests
    
    try:
        current_site = Site.objects.get_current()
        sitemap_url = f"https://{current_site.domain}/sitemap.xml"
    except:
        sitemap_url = "https://pokedev-django-production.up.railway.app/sitemap.xml"
    
    # URLs de ping des moteurs de recherche
    ping_urls = [
        f"http://www.google.com/webmasters/tools/ping?sitemap={sitemap_url}",
        f"http://www.bing.com/webmaster/ping.aspx?siteMap={sitemap_url}",
    ]
    
    results = []
    for ping_url in ping_urls:
        try:
            response = requests.get(ping_url, timeout=10)
            results.append({
                'url': ping_url,
                'status': response.status_code,
                'success': response.status_code == 200
            })
            print(f"Ping {ping_url}: {response.status_code}")
        except Exception as e:
            results.append({
                'url': ping_url,
                'status': 'error',
                'success': False,
                'error': str(e)
            })
            print(f"Erreur ping {ping_url}: {e}")
    
    return results

def get_robots_content(request=None):
    """Génère le contenu du robots.txt"""
    try:
        current_site = Site.objects.get_current()
        domain = f"https://{current_site.domain}"
    except:
        domain = "https://pokedev-django-production.up.railway.app"
    
    content = f"""User-agent: *

# Pages autorisées
Allow: /
Allow: /languages/
Allow: /languages/*/

# Pages interdites
Disallow: /admin/
Disallow: /api/
Disallow: /__debug__/
Disallow: /static/
Disallow: /media/
Disallow: /utilisateurs/
Disallow: /stats/
Disallow: /outils/
Disallow: /db-docs/

# Sitemap
Sitemap: {domain}/sitemap.xml

# Délai entre requêtes
Crawl-delay: 1
"""
    
    return content
