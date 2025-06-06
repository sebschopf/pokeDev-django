# Generated by Django 5.2.1 on 2025-05-25 07:19

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('contenttypes', '0002_remove_content_type_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='SEOConfig',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('site_name', models.CharField(default='PokeDev', max_length=100)),
                ('site_description', models.TextField(default='Cartes interactives des langages de programmation')),
                ('default_keywords', models.CharField(default='langages programmation, frameworks, développement', max_length=255)),
                ('og_image', models.URLField(blank=True, null=True)),
                ('twitter_handle', models.CharField(blank=True, max_length=50, null=True)),
            ],
            options={
                'verbose_name': 'Configuration SEO',
                'verbose_name_plural': 'Configurations SEO',
            },
        ),
        migrations.CreateModel(
            name='SEOMetadata',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('object_id', models.PositiveIntegerField()),
                ('custom_title', models.CharField(blank=True, max_length=60, null=True)),
                ('custom_description', models.CharField(blank=True, max_length=160, null=True)),
                ('custom_keywords', models.CharField(blank=True, max_length=255, null=True)),
                ('no_index', models.BooleanField(default=False)),
                ('no_follow', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('content_type', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='contenttypes.contenttype')),
            ],
            options={
                'verbose_name': 'Métadonnée SEO',
                'verbose_name_plural': 'Métadonnées SEO',
                'unique_together': {('content_type', 'object_id')},
            },
        ),
    ]
