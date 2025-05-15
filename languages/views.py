# languages/views.py
from django.shortcuts import render, get_object_or_404
from .models import Languages

def list(request):
    list = Languages.objects.all()
    return render(request, 'languages/list.html', {'languages': list})

def detail(request, slug):
    language = get_object_or_404(Languages, slug=slug)
    return render(request, 'languages/detail.html', {'language': language})
