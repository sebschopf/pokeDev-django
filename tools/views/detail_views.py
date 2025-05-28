from django.views.generic import DetailView
from tools.models import Tool

class ToolDetailView(DetailView):
    model = Tool
    template_name = 'tools/detail.html'
    context_object_name = 'tool'