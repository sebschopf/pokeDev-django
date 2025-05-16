import requests
from django import forms
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from .models import Profile

class ProfileForm(forms.ModelForm):
    """
    Formulaire pour modifier le profil utilisateur.
    """
    class Meta:
        model = Profile
        fields = ['username', 'full_name', 'bio', 'website', 'avatar_url']
        labels = {
            'username': "Nom d'utilisateur",
            'full_name': 'Nom complet',
            'bio': 'Biographie',
            'website': 'Site web',
            'avatar_url': 'Photo de profil (URL)'
        }
        widgets = {
            'username': forms.TextInput(attrs={'class': 'form-control w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'}),
            'full_name': forms.TextInput(attrs={'class': 'form-control w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'}),
            'bio': forms.Textarea(attrs={'rows': 4, 'class': 'form-control w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'}),
            'website': forms.URLInput(attrs={'class': 'form-control w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'}),
            'avatar_url': forms.URLInput(attrs={'class': 'form-control w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500', 'placeholder': 'https://exemple.com/image.jpg'}),
        }
    
    def clean_avatar_url(self):
        """
        Valide que l'URL fournie pointe vers une image.
        Si l'URL est vide, aucune validation n'est effectuée.
        """
        url = self.cleaned_data.get('avatar_url')
        if not url:
            return url
            
        try:
            # Vérifier que l'URL est accessible
            response = requests.head(url, timeout=5)
            if response.status_code != 200:
                raise ValidationError("L'URL fournie n'est pas accessible.")
                
            # Vérifier que c'est bien une image
            content_type = response.headers.get('Content-Type', '')
            if not content_type.startswith('image/'):
                raise ValidationError("L'URL ne pointe pas vers une image valide.")
                
        except requests.RequestException:
            raise ValidationError("Impossible de vérifier l'URL. Veuillez vous assurer qu'elle est correcte.")
            
        return url

class CustomUserCreationForm(UserCreationForm):
    """
    Formulaire d'inscription personnalisé avec champ email.
    """
    email = forms.EmailField(
        required=True, 
        help_text="Requis. Entrez une adresse e-mail valide.",
        widget=forms.EmailInput(attrs={'class': 'mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'})
    )
    
    class Meta:
        model = User
        fields = ("username", "email", "password1", "password2")
        
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Ajouter des classes CSS aux champs existants
        self.fields['username'].widget.attrs.update({
            'class': 'mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'
        })
        self.fields['password1'].widget.attrs.update({
            'class': 'mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'
        })
        self.fields['password2'].widget.attrs.update({
            'class': 'mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500'
        })

    def save(self, commit=True):
        user = super().save(commit=False)
        user.email = self.cleaned_data["email"]
        if commit:
            user.save()
        return user
        
    def clean_email(self):
        email = self.cleaned_data.get('email')
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError("Cette adresse e-mail est déjà utilisée.")
        return email
