# languages/views.py
from django.shortcuts import render, get_object_or_404
from .models import ProgrammingLanguage, Framework

def language_list(request):
    languages = ProgrammingLanguage.objects.all()
    return render(request, 'languages/language_list.html', {'languages': languages})

def language_detail(request, slug):
    language = get_object_or_404(ProgrammingLanguage, slug=slug)
    return render(request, 'languages/language_detail.html', {'language': language})

def framework_detail(request, language_slug, framework_slug):
    framework = get_object_or_404(Framework, slug=framework_slug, language__slug=language_slug)
    return render(request, 'languages/framework_detail.html', {'framework': framework})