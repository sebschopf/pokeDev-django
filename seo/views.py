from django.shortcuts import render

# views.py
from django.http import HttpResponse
from django.template import loader
from django.urls import reverse
from django.utils import timezone
from django.contrib.sites.models import Site
from languages.models import Languages
from django.views.decorators.http import require_GET
from django.views.decorators.cache import cache_page

@require_GET
@cache_page(60 * 60 * 24)  # Cache pendant 24h
def sitemap_xml(request):
    """Génère le sitemap.xml dynamiquement"""
    
    # Obtenir le domaine actuel
    current_site = Site.objects.get_current()
    domain = f"https://{current_site.domain}"
    
    # URLs statiques importantes
    static_urls = [
        {
            'location': domain + '/',
            'lastmod': timezone.now(),
            'changefreq': 'daily',
            'priority': '1.0'
        },
        {
            'location': domain + reverse('languages:list'),
            'lastmod': timezone.now(),
            'changefreq': 'daily',
            'priority': '0.9'
        },
        {
            'location': domain + reverse('languages:accessibility_methodology'),
            'lastmod': timezone.now(),
            'changefreq': 'monthly',
            'priority': '0.7'
        },
        {
            'location': domain + reverse('dependencies:tribute'),
            'lastmod': timezone.now(),
            'changefreq': 'monthly',
            'priority': '0.5'
        }
    ]
    
    # URLs des langages
    language_urls = []
    languages = Languages.objects.filter(is_active=True).order_by('name')
    
    for language in languages:
        language_urls.append({
            'location': domain + reverse('languages:detail', kwargs={'slug': language.slug}),
            'lastmod': language.updated_at,
            'changefreq': 'weekly',
            'priority': '0.8'
        })
    
    # Combiner toutes les URLs
    all_urls = static_urls + language_urls
    
    # Template XML
    template = loader.get_template('seo/sitemap.xml')
    context = {
        'urls': all_urls,
        'domain': domain
    }
    
    xml_content = template.render(context, request)
    return HttpResponse(xml_content, content_type='application/xml')

@require_GET
def robots_txt(request):
    """Vue pour servir robots.txt"""
    current_site = Site.objects.get_current()
    domain = f"https://{current_site.domain}"
    
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
    
    return HttpResponse(content, content_type='text/plain')
