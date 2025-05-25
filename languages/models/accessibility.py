# languages/models/accessibility.py
from django.db import models
from .language import Languages

class AccessibilityLevels(models.Model):
    id = models.AutoField(primary_key=True)
    level_number = models.IntegerField(db_index=True)
    name = models.CharField(max_length=50)  # Ajusté selon la DB
    description = models.TextField()
    prerequisites = models.TextField()
    estimated_learning_time = models.CharField(max_length=50)  # Ajusté selon la DB
    level_order = models.IntegerField(db_index=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'accessibility_levels'
        verbose_name = 'Niveau d\'accessibilité'
        verbose_name_plural = 'Niveaux d\'accessibilité'
        ordering = ['level_order']
        indexes = [
            models.Index(fields=['level_number']),
            models.Index(fields=['level_order']),
        ]

    def __str__(self):
        return f"{self.level_number}. {self.name}"

    @classmethod
    def get_level_by_number(cls, level_number):
        """
        Récupère un niveau d'accessibilité par son numéro
        """
        try:
            return cls.objects.get(level_number=level_number)
        except cls.DoesNotExist:
            return None

    @classmethod
    def get_all_ordered(cls):
        """
        Récupère tous les niveaux d'accessibilité ordonnés
        """
        return cls.objects.all().order_by('level_order')


class AccessibilityCriteria(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    weight = models.FloatField(default=0, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'accessibility_criteria'
        verbose_name = 'Critère d\'accessibilité'
        verbose_name_plural = 'Critères d\'accessibilité'
        ordering = ['-weight', 'name']
        indexes = [
            models.Index(fields=['weight']),
        ]

    def __str__(self):
        return self.name


class LanguageAccessibilityLevels(models.Model):
    id = models.AutoField(primary_key=True)
    language = models.ForeignKey(Languages, models.DO_NOTHING, db_index=True)
    accessibility_level = models.ForeignKey(AccessibilityLevels, models.DO_NOTHING, db_index=True)
    notes = models.TextField(blank=True, null=True)
    accessibility_score = models.FloatField(blank=True, null=True, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # Champ manquant ajouté selon la structure DB
    score_explanation = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'language_accessibility_levels'
        verbose_name = 'Niveau d\'accessibilité du langage'
        verbose_name_plural = 'Niveaux d\'accessibilité des langages'
        unique_together = (('language', 'accessibility_level'),)
        indexes = [
            models.Index(fields=['accessibility_score']),
        ]

    def __str__(self):
        return f"{self.language.name} - {self.accessibility_level.name}"

    @classmethod
    def get_languages_by_level(cls, level_number):
        """
        Récupère tous les langages pour un niveau d'accessibilité donné
        """
        return cls.objects.filter(
            accessibility_level__level_number=level_number
        ).select_related('language', 'accessibility_level')

    @classmethod
    def get_top_languages_by_level(cls, level_number, limit=5):
        """
        Récupère les langages les mieux notés pour un niveau d'accessibilité donné
        """
        return cls.objects.filter(
            accessibility_level__level_number=level_number
        ).select_related('language', 'accessibility_level').order_by(
            '-accessibility_score'
        )[:limit]


class LanguageAccessibilityEvaluations(models.Model):
    id = models.AutoField(primary_key=True)
    language_accessibility_level = models.ForeignKey(
        LanguageAccessibilityLevels, 
        models.DO_NOTHING, 
        db_column='language_accessibility_level_id'
    )
    criteria = models.ForeignKey(
        AccessibilityCriteria, 
        models.DO_NOTHING, 
        db_column='criteria_id'
    )
    score = models.FloatField(db_column='score')
    justification = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'language_accessibility_evaluations'
        verbose_name = 'Évaluation d\'accessibilité'
        verbose_name_plural = 'Évaluations d\'accessibilité'
        unique_together = (('language_accessibility_level', 'criteria'),)
        indexes = [
            models.Index(fields=['score']),
        ]

    def __str__(self):
        return f"{self.language_accessibility_level.language.name} - {self.criteria.name}: {self.score}"
    
    @property
    def language(self):
        """
        Propriété pour accéder facilement au langage associé
        """
        return self.language_accessibility_level.language
