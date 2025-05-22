from django.shortcuts import render, get_object_or_404
from django.views.generic import ListView, DetailView
from ..models.db_docs import DbDocsChapter, DbDocsSection

class ChapterListView(ListView):
    model = DbDocsChapter
    template_name = 'languages/db_docs/chapter_list.html'
    context_object_name = 'chapters'
    
    def get_queryset(self):
        return DbDocsChapter.objects.all().order_by('order')

class ChapterDetailView(DetailView):
    model = DbDocsChapter
    template_name = 'languages/db_docs/chapter_detail.html'
    context_object_name = 'chapter'
    slug_field = 'slug'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        chapter = self.get_object()
        
        # Récupérer les sections du chapitre
        sections = DbDocsSection.objects.filter(chapter=chapter).order_by('order')
        context['sections'] = sections
        
        # Récupérer tous les chapitres pour la navigation
        context['all_chapters'] = DbDocsChapter.objects.all().order_by('order')
        
        return context