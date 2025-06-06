# Generated by Django 5.2.1 on 2025-05-16 13:49

import django.contrib.postgres.fields
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Corrections',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('language_id', models.IntegerField(blank=True, null=True)),
                ('field_name', models.CharField(max_length=50)),
                ('current_value', models.TextField(blank=True, null=True)),
                ('proposed_value', models.TextField()),
                ('submitted_by', models.UUIDField(blank=True, null=True)),
                ('status', models.CharField(default='pending', max_length=50)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('reviewer_id', models.UUIDField(blank=True, null=True)),
                ('review_notes', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'corrections',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='LanguageProposals',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('description', models.TextField()),
                ('submitted_by', models.UUIDField(blank=True, null=True)),
                ('status', models.CharField(default='pending', max_length=50)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('reviewer_id', models.UUIDField(blank=True, null=True)),
                ('review_notes', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'language_proposals',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Languages',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('short_description', models.TextField(blank=True, null=True)),
                ('logo_path', models.CharField(blank=True, max_length=255, null=True)),
                ('slug', models.CharField(max_length=255, unique=True)),
                ('type', models.CharField(blank=True, max_length=50, null=True)),
                ('used_for', models.TextField(blank=True, null=True)),
                ('usage_rate', models.FloatField(blank=True, null=True)),
                ('year_created', models.IntegerField(blank=True, null=True)),
                ('creator', models.CharField(blank=True, max_length=255, null=True)),
                ('popular_frameworks', django.contrib.postgres.fields.ArrayField(base_field=models.CharField(max_length=255), blank=True, null=True, size=None)),
                ('strengths', django.contrib.postgres.fields.ArrayField(base_field=models.CharField(max_length=255), blank=True, null=True, size=None)),
                ('is_open_source', models.BooleanField(default=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={
                'db_table': 'languages',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='LanguagesFramework',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('slug', models.CharField(max_length=50, unique=True)),
                ('description', models.TextField()),
                ('website', models.CharField(max_length=200)),
                ('created_at', models.DateTimeField()),
                ('updated_at', models.DateTimeField()),
            ],
            options={
                'db_table': 'languages_framework',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='LanguageUsage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(blank=True, null=True)),
            ],
            options={
                'db_table': 'language_usage',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Libraries',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('description', models.TextField(blank=True, null=True)),
                ('logo_path', models.CharField(blank=True, max_length=255, null=True)),
                ('technology_type', models.CharField(blank=True, max_length=50, null=True)),
                ('website_url', models.URLField(blank=True, null=True)),
                ('github_url', models.URLField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={
                'verbose_name_plural': 'libraries',
                'db_table': 'libraries',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='LibraryLanguages',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'db_table': 'library_languages',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='TechnologyCategories',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={
                'verbose_name_plural': 'technology categories',
                'db_table': 'technology_categories',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='TechnologySubtypes',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('description', models.TextField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
            ],
            options={
                'db_table': 'technology_subtypes',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='UsageCategories',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('created_at', models.DateTimeField(blank=True, null=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('updated_at', models.DateTimeField(blank=True, null=True)),
            ],
            options={
                'db_table': 'usage_categories',
                'managed': False,
            },
        ),
    ]
