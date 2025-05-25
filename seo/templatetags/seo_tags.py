from django import template
from django.utils.safestring import mark_safe
from ..utils import generate_seo_context
import json

register = template.Library()

@register.inclusion_tag('seo/meta_tags.html', takes_context=True)
def seo_meta_tags(context, obj=None):
    """Génère automatiquement tous les meta tags SEO"""
    request = context.get('request')
    
    if obj:
        seo_context = generate_seo_context(obj, request)
    else:
        # Métadonnées par défaut pour les pages sans objet spécifique
        from ..models import SEOConfig
        try:
            config = SEOConfig.objects.first()
        except:
            config = None
            
        seo_context = {
            'seo_title': config.site_name if config else 'PokeDev',
            'seo_description': config.site_description if config else 'Cartes interactives des langages de programmation',
            'seo_keywords': config.default_keywords if config else 'programmation, langages',
            'seo_robots': 'index, follow',
            'seo_canonical': request.build_absolute_uri() if request else None,
            'seo_og_image': config.og_image if config else None,
            'seo_structured_data': json.dumps({
                "@context": "https://schema.org",
                "@type": "WebSite",
                "name": config.site_name if config else 'PokeDev'
            })
        }
    
    # Retourner seulement les données SEO, pas tout le contexte
    return seo_context

@register.inclusion_tag('seo/breadcrumbs.html', takes_context=True)
def seo_breadcrumbs(context, obj=None, custom_breadcrumbs=None):
    """Génère des breadcrumbs SEO"""
    request = context.get('request')
    
    if custom_breadcrumbs:
        breadcrumbs = custom_breadcrumbs
    elif obj:
        # Générer automatiquement selon le type d'objet
        breadcrumbs = []
        
        if obj._meta.model_name == 'language':
            breadcrumbs = [
                {'name': 'Accueil', 'url': '/'},
                {'name': 'Langages', 'url': '/languages/'},
                {'name': obj.name, 'url': None}  # Page actuelle
            ]
        elif obj._meta.model_name == 'library':
            breadcrumbs = [
                {'name': 'Accueil', 'url': '/'},
                {'name': 'Langages', 'url': '/languages/'},
                {'name': obj.language.name, 'url': f'/languages/{obj.language.slug}/'},
                {'name': obj.name, 'url': None}
            ]
    else:
        breadcrumbs = [{'name': 'Accueil', 'url': '/'}]
    
    return {'breadcrumbs': breadcrumbs}

@register.simple_tag(takes_context=True)
def seo_title(context, obj=None):
    """Génère juste le titre SEO"""
    request = context.get('request')
    if obj:
        try:
            seo_data = generate_seo_context(obj, request)
            return seo_data['seo_title']
        except:
            pass
    return 'PokeDev'

@register.simple_tag(takes_context=True)
def seo_description(context, obj=None):
    """Génère juste la description SEO"""
    request = context.get('request')
    if obj:
        try:
            seo_data = generate_seo_context(obj, request)
            return seo_data['seo_description']
        except:
            pass
    return 'Cartes interactives des langages de programmation'

@register.simple_tag(takes_context=True)
def seo_keywords(context, obj=None):
    """Génère juste les mots-clés SEO - TAG MANQUANT !"""
    request = context.get('request')
    if obj:
        try:
            seo_data = generate_seo_context(obj, request)
            return seo_data['seo_keywords']
        except:
            pass
    return 'programmation, langages, développement'
