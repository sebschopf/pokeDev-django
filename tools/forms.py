from django import forms
from .models import Tool

class ToolCorrectionForm(forms.Form):
    field = forms.ChoiceField(choices=[], label="Champ à corriger")
    correction_text = forms.CharField(widget=forms.Textarea, label="Nouvelle valeur")
    suggestion = forms.CharField(widget=forms.Textarea, label="Justification de la correction")

    def __init__(self, *args, tool=None, **kwargs):
        super().__init__(*args, **kwargs)
        # Liste des champs modifiables
        tool_fields = []
        excluded_fields = ['id', 'created_at', 'updated_at']
        for field in Tool._meta.fields:
            if field.name not in excluded_fields:
                label = field.verbose_name or field.name.replace('_', ' ').capitalize()
                tool_fields.append((field.name, f"{label}"))
        self.fields['field'].choices = tool_fields

        # Ajoute du style
        self.fields['field'].widget.attrs.update({'class': 'w-full border-4 border-black p-3 font-bold'})
        self.fields['correction_text'].widget.attrs.update({'class': 'w-full border-4 border-black p-3 font-bold', 'rows': 4})
        self.fields['suggestion'].widget.attrs.update({'class': 'w-full border-4 border-black p-3 font-bold', 'rows': 4})

# Ce formulaire est utilisé pour proposer des corrections sur les outils.
class ToolForm(forms.ModelForm):
    class Meta:
        model = Tool
        fields = '__all__'