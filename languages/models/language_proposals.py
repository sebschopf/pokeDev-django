from django.db import models

class LanguageProposals(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    submitted_by = models.UUIDField(blank=True, null=True)
    status = models.CharField(max_length=50, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    reviewer_id = models.UUIDField(blank=True, null=True)
    review_notes = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'language_proposals'

    def __str__(self):
        return f"{self.name} ({self.status})"