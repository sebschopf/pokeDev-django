from django.urls import path
from .views.tool_search import ToolSearchView
from .views.api_views import (
    api_tools_by_language,
    api_categories_by_language,
    api_subtypes_by_category,
    api_search_tools,
    api_tool_detail,
)
from .views.detail_views import ToolDetailView

app_name = 'tools'

urlpatterns = [
    path('', ToolSearchView.as_view(), name='search'),
    path('<int:pk>/', ToolDetailView.as_view(), name='detail'),
    # API endpoints
    path('api/by-language/<int:language_id>/', api_tools_by_language, name='api_tools_by_language'),
    path('api/categories/by-language/<int:language_id>/', api_categories_by_language, name='api_categories_by_language'),
    path('api/subtypes/by-category/<int:category_id>/', api_subtypes_by_category, name='api_subtypes_by_category'),
    path('api/search/', api_search_tools, name='api_search_tools'),
    path('api/detail/<int:tool_id>/', api_tool_detail, name='api_tool_detail'),
    # Tu ajouteras ici la vue de détail plus tard
]