# languages/forms.py
from django import forms
from .models.corrections import Corrections

class ReviewCorrectionForm(forms.ModelForm):
    class Meta:
        model = Corrections
        fields = ['status', 'suggestion']
        widgets = {
            'status': forms.Select(choices=[
                ('pending', 'En attente'),
                ('approved', 'Approuvée'),
                ('rejected', 'Rejetée'),
            ]),
            'suggestion': forms.Textarea(attrs={'rows': 4}),
        }
        labels = {
            'status': 'Statut',
            'suggestion': 'Commentaire du réviseur'
        }

class SubmitCorrectionForm(forms.ModelForm):
    class Meta:
        model = Corrections
        fields = ['field', 'correction_text', 'suggestion']
        widgets = {
            'field': forms.Select(choices=[
                ('name', 'Nom'),
                ('description', 'Description'),
                ('creator', 'Créateur'),
                ('year_created', 'Année de création'),
                ('website', 'Site web'),
                ('type', 'Type'),
                ('is_open_source', 'Open Source'),
                ('logo_svg', 'Logo (SVG)'),
                ('strengths', 'Points forts'),
                ('used_for', 'Utilisé pour'),
            ]),
            'correction_text': forms.Textarea(attrs={'rows': 6}),
            'suggestion': forms.Textarea(attrs={'rows': 4}),
        }
        labels = {
            'field': 'Champ à corriger',
            'correction_text': 'Nouvelle valeur',
            'suggestion': 'Justification de la correction',
        }