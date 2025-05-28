from django.http import JsonResponse
from django.views.decorators.http import require_GET
from tools.models import Tool, TechnologyCategory

@require_GET
def api_tools_by_language(request, language_id):
    """
    API REST optimisée pour obtenir les outils (tools) liés à un langage donné,
    groupés par catégorie. Retourne pour chaque catégorie la liste des outils associés,
    avec sous-catégories et langages pour chaque outil.
    """
    # Précharge les catégories pour éviter le N+1
    categories = TechnologyCategory.objects.all()
    # Prépare la structure de regroupement
    category_map = {cat.id: {"category": cat.type, "tools": []} for cat in categories}

    # Précharge les relations pour limiter les requêtes SQL
    tools_qs = (
        Tool.objects.filter(languages__id=language_id)
        .select_related('technology_category')
        .prefetch_related('technology_subtypes', 'languages')
        .only('id', 'name', 'description', 'logo_path', 'official_website', 'technology_category')
        .distinct()
    )

    for tool in tools_qs:
        cat_id = tool.technology_category_id
        if cat_id in category_map:
            category_map[cat_id]["tools"].append({
                "id": tool.id,
                "name": tool.name,
                "description": tool.description,
                "logo_path": tool.logo_path,
                "official_website": tool.official_website,
                "subtypes": [sub.name for sub in tool.technology_subtypes.all()],
                "languages": [lang.name for lang in tool.languages.all()],
            })

    # On ne garde que les catégories ayant au moins un outil
    results = [cat for cat in category_map.values() if cat["tools"]]
    return JsonResponse({"results": results})

@require_GET
def api_categories_by_language(request, language_id):
    """
    Retourne les catégories qui ont au moins un outil lié à ce langage.
    """
    categories = TechnologyCategory.objects.filter(
        tools__languages__id=language_id
    ).distinct().values('id', 'type')
    return JsonResponse({"categories": list(categories)})

@require_GET
def api_subtypes_by_category(request, category_id, language_id=None):
    """
    Retourne les sous-catégories d'une catégorie, optionnellement filtrées par langage.
    """
    from tools.models import TechnologySubtype
    subtypes = TechnologySubtype.objects.filter(category_id=category_id)
    if language_id:
        subtypes = subtypes.filter(
            tools__languages__id=language_id
        ).distinct()
    subtypes = subtypes.values('id', 'name')
    return JsonResponse({"subtypes": list(subtypes)})

@require_GET
def api_search_tools(request):
    """
    Recherche d'outils via API (nom, catégorie, sous-catégorie, langage).
    """
    qs = Tool.objects.all().distinct()
    name = request.GET.get('name')
    category = request.GET.get('category')
    subtype = request.GET.get('subtype')
    language = request.GET.get('language')
    if name:
        qs = qs.filter(name__icontains=name)
    if category:
        qs = qs.filter(technology_category_id=category)
    if subtype:
        qs = qs.filter(technology_subtypes__id=subtype)
    if language:
        qs = qs.filter(languages__id=language)
    data = [
        {
            "id": t.id,
            "name": t.name,
            "description": t.description,
            "logo_path": t.logo_path,
        }
        for t in qs[:20]  # Limite pour éviter surcharge
    ]
    return JsonResponse({"tools": data})

@require_GET
def api_tool_detail(request, tool_id):
    """
    Détail d'un outil (tool) avec toutes ses relations (catégorie, sous-catégories, langages).
    """
    tool = Tool.objects.select_related('technology_category').prefetch_related('technology_subtypes', 'languages').get(id=tool_id)
    data = {
        "id": tool.id,
        "name": tool.name,
        "description": tool.description,
        "usage": tool.usage,
        "category": tool.technology_category.type if tool.technology_category else None,
        "subtypes": [s.name for s in tool.technology_subtypes.all()],
        "languages": [l.name for l in tool.languages.all()],
        "official_website": tool.official_website,
        "documentation_url": tool.documentation_url,
        "is_open_source": tool.is_open_source,
        "license": tool.license,
        "logo_path": tool.logo_path,
        "author": tool.author,
    }
    return JsonResponse(data)