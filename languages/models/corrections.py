# languages/models/corrections.py
from django.db import models
from django.contrib.auth.models import User
from django.contrib.auth import get_user_model

class Corrections(models.Model):
    # Choix pour le statut
    STATUS_CHOICES = [
        ('pending', 'En attente'),
        ('approved', 'Approuvée'),
        ('rejected', 'Rejetée'),
    ]
    
    # Champs existants dans la base de données
    id = models.AutoField(primary_key=True)  # Django ajoute automatiquement l'ID
    language = models.ForeignKey('Languages', models.DO_NOTHING)
    framework = models.TextField(blank=True, null=True)
    correction_text = models.TextField()
    status = models.TextField(choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    field = models.CharField(max_length=100, blank=True, null=True)
    suggestion = models.TextField(blank=True, null=True)
    user_id = models.UUIDField(blank=True, null=True)
    reviewed_by = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, blank=True, related_name='reviewed_corrections')
    reviewed_at = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"Correction pour {self.language.name if hasattr(self.language, 'name') else 'inconnu'} - {self.field or 'général'}"
    
    class Meta:
        managed = False  # Important : ne pas laisser Django gérer cette table
        db_table = 'corrections'
        db_table_comment = 'table des corrections et des status'