from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse

# Vue temporaire simple
def tool_detail(request, slug):
    # Pour l'instant, juste une page temporaire
    return render(request, 'tools/detail.html', {'slug': slug})
