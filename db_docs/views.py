# db_docs/views.py
from django.shortcuts import render, get_object_or_404
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.decorators import user_passes_test
from django.utils.decorators import method_decorator
from django.views.generic import ListView, DetailView

from .models import Chapter, Section
from .utils.db_inspector import get_database_info

def is_admin(user):
    """Vérifie si l'utilisateur est administrateur"""
    return user.is_authenticated and user.is_superuser

@user_passes_test(is_admin)
def index(request):
    """Vue principale de la documentation"""
    chapters = Chapter.objects.all()
    db_info = get_database_info()
    
    return render(request, 'db_docs/index.html', {
        'chapters': chapters,
        'db_info': db_info,
    })

@method_decorator(user_passes_test(is_admin), name='dispatch')
class ChapterDetailView(DetailView):
    """Affiche le détail d'un chapitre"""
    model = Chapter
    template_name = 'db_docs/chapter_detail.html'
    context_object_name = 'chapter'
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['chapters'] = Chapter.objects.all()
        context['sections'] = self.object.sections.all()
        
        # Ajouter des informations spécifiques selon le chapitre
        if self.object.slug == 'schemas':
            context['schemas_info'] = get_database_info().get('schemas', [])
        elif self.object.slug == 'tables':
            context['tables_info'] = get_database_info().get('tables', [])
        # Ajouter d'autres conditions pour les autres chapitres
        
        return context