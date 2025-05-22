# languages/forms.py
from django import forms
from .models.corrections import Corrections
from .models.language import Languages
from .models.features import Features, LanguageFeatures
from .models.accessibility import AccessibilityLevels, LanguageAccessibilityLevels
from .models.library import Libraries
from django.utils.translation import gettext_lazy as _

class DynamicCorrectionForm(forms.ModelForm):
    """Formulaire de correction qui génère dynamiquement les choix de champs à partir du modèle Languages"""
    
    # Définir explicitement le champ 'field' comme ChoiceField
    field = forms.ChoiceField(choices=[], label="Champ à corriger")
    
    def __init__(self, *args, language_id=None, **kwargs):
        super().__init__(*args, **kwargs)
        
        # Récupérer tous les champs du modèle Languages qui peuvent être corrigés
        language_fields = []
        excluded_fields = ['id', 'created_at', 'updated_at']
        
        # Correction de l'erreur : itérer correctement sur les champs
        for field in Languages._meta.fields:
            field_name = field.name
            if field_name not in excluded_fields:
                # Déterminer le type de champ pour l'affichage
                field_type = type(field).__name__
                field_label = field.verbose_name or field_name.replace('_', ' ').capitalize()
                language_fields.append((field_name, f"{field_label} ({field_type})"))
        
        # Ajouter les champs spéciaux qui ne sont pas directement dans le modèle
        special_fields = [
            ('strengths', 'Points forts (Liste)'),
            ('popular_frameworks', 'Frameworks populaires (Liste)'),
            ('tools', 'Outils associés (JSON)'),
        ]
        
        # Ajouter les champs pour les caractéristiques
        feature_fields = []
        if language_id:
            # Récupérer toutes les caractéristiques du langage
            language_features = LanguageFeatures.objects.filter(language_id=language_id).select_related('feature')
            for lf in language_features:
                feature_fields.append((
                    f"feature_{lf.feature.id}", 
                    f"Caractéristique: {lf.feature.name} ({lf.feature.feature_type})"
                ))
        
        # Ajouter les champs pour l'accessibilité
        accessibility_fields = []
        if language_id:
            # Récupérer tous les niveaux d'accessibilité du langage
            language_accessibility = LanguageAccessibilityLevels.objects.filter(language_id=language_id).select_related('accessibility_level')
            for la in language_accessibility:
                accessibility_fields.append((
                    f"accessibility_{la.accessibility_level.id}", 
                    f"Accessibilité: {la.accessibility_level.name} (Score: {la.accessibility_score})"
                ))
        
        # Combiner les listes et trier par nom de champ
        all_fields = sorted(language_fields + special_fields + feature_fields + accessibility_fields, key=lambda x: x[1])
        
        # Mettre à jour les choix du champ 'field'
        self.fields['field'].choices = all_fields
        
        # Personnaliser l'apparence des champs
        self.fields['field'].widget.attrs.update({
            'class': 'w-full border-4 border-black p-3 font-bold'
        })
        self.fields['correction_text'].widget.attrs.update({
            'class': 'w-full border-4 border-black p-3 font-bold',
            'rows': 4
        })
        self.fields['suggestion'].widget.attrs.update({
            'class': 'w-full border-4 border-black p-3 font-bold',
            'rows': 4
        })
    
    class Meta:
        model = Corrections
        fields = ['field', 'correction_text', 'suggestion']
        labels = {
            'field': 'Champ à corriger',
            'correction_text': 'Nouvelle valeur',
            'suggestion': 'Justification de la correction',
        }
        help_texts = {
            'field': _('Sélectionnez le champ que vous souhaitez corriger.'),
            'correction_text': _('Entrez la nouvelle valeur pour ce champ.'),
            'suggestion': _('Expliquez pourquoi cette correction est nécessaire.'),
        }

class ReviewCorrectionForm(forms.ModelForm):
    class Meta:
        model = Corrections
        fields = ['status', 'suggestion']
        widgets = {
            'status': forms.Select(choices=[
                ('pending', 'En attente'),
                ('approved', 'Approuvée'),
                ('rejected', 'Rejetée'),
            ], attrs={'class': 'w-full border-4 border-black p-3 font-bold'}),
            'suggestion': forms.Textarea(attrs={
                'rows': 4,
                'class': 'w-full border-4 border-black p-3 font-bold'
            }),
        }
        labels = {
            'status': 'Statut',
            'suggestion': 'Commentaire du réviseur'
        }
        help_texts = {
            'status': _('Choisissez si vous approuvez ou rejetez cette correction.'),
            'suggestion': _('Laissez un commentaire expliquant votre décision.'),
        }