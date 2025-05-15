from django.db import models

class Profile(models.Model):
    user_id = models.UUIDField(primary_key=True)
    username = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    avatar_url = models.TextField(blank=True, null=True)
    full_name = models.TextField(blank=True, null=True)
    bio = models.TextField(blank=True, null=True)
    website = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'profiles'

    def __str__(self):
        return self.username or str(self.user_id)