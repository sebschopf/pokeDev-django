# stats/models.py
from django.db import models
from languages.models import Languages

class StatsLanguages(models.Model):
    id = models.BigAutoField(primary_key=True)
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    views_count = models.BigIntegerField(blank=True, null=True)
    likes_count = models.BigIntegerField(blank=True, null=True)
    shares_count = models.BigIntegerField(blank=True, null=True)
    last_updated = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stats_languages'
    
    def __str__(self):
        return f"Stats for {self.language}"

class StatsSearches(models.Model):
    id = models.BigAutoField(primary_key=True)
    search_term = models.TextField()
    user_id = models.UUIDField(blank=True, null=True)
    results_count = models.IntegerField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stats_searches'
    
    def __str__(self):
        return self.search_term

class StatsUsers(models.Model):
    id = models.BigAutoField(primary_key=True)
    user_id = models.UUIDField()
    contributions_count = models.BigIntegerField(blank=True, null=True)
    corrections_count = models.BigIntegerField(blank=True, null=True)
    proposals_count = models.BigIntegerField(blank=True, null=True)
    last_activity = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stats_users'
    
    def __str__(self):
        return f"Stats for user {self.user_id}"

class StatsVisits(models.Model):
    id = models.BigAutoField(primary_key=True)
    page_path = models.TextField()
    user_id = models.UUIDField(blank=True, null=True)
    referrer = models.TextField(blank=True, null=True)
    user_agent = models.TextField(blank=True, null=True)
    ip_address = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    session_id = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stats_visits'
    
    def __str__(self):
        return f"Visit to {self.page_path}"