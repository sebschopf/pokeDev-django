from django.db import models

class DbDocsChapter(models.Model):
    title = models.CharField(max_length=200)
    slug = models.CharField(max_length=50)
    order = models.IntegerField()
    description = models.TextField()

    class Meta:
        managed = False
        db_table = 'db_docs_chapter'
        ordering = ['order']

    def __str__(self):
        return self.title

class DbDocsSection(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    sql_example = models.TextField(blank=True)
    order = models.IntegerField()
    chapter = models.ForeignKey(DbDocsChapter, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'db_docs_section'
        ordering = ['chapter__order', 'order']

    def __str__(self):
        return f"{self.chapter.title} - {self.title}"