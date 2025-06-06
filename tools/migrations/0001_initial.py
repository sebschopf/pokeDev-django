# Generated by Django 5.2.1 on 2025-05-28 16:31

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('languages', '0004_features_delete_languagefeature_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='TechnologyCategory',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('type', models.CharField(max_length=255, unique=True)),
                ('icon_name', models.CharField(blank=True, max_length=255, null=True)),
                ('color', models.CharField(blank=True, max_length=255, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'db_table': 'technology_category',
            },
        ),
        migrations.CreateModel(
            name='TechnologySubtype',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(db_index=True, max_length=255)),
                ('description', models.TextField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('category', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='subtypes', to='tools.technologycategory')),
            ],
            options={
                'db_table': 'technology_subtype',
            },
        ),
        migrations.CreateModel(
            name='Tool',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('usage', models.TextField(blank=True, null=True)),
                ('type_id', models.IntegerField(blank=True, null=True)),
                ('official_website', models.URLField(blank=True, null=True)),
                ('documentation_url', models.URLField(blank=True, null=True)),
                ('is_open_source', models.BooleanField(default=False)),
                ('license', models.CharField(blank=True, max_length=255, null=True)),
                ('logo_path', models.CharField(blank=True, max_length=255, null=True)),
                ('author', models.CharField(blank=True, max_length=255, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('languages', models.ManyToManyField(blank=True, related_name='tools', to='languages.languages')),
                ('technology_category', models.ForeignKey(blank=True, db_column='technology_category_id', null=True, on_delete=django.db.models.deletion.SET_NULL, to='tools.technologycategory')),
                ('technology_subtypes', models.ManyToManyField(blank=True, related_name='tools', to='tools.technologysubtype')),
            ],
            options={
                'db_table': 'tool',
            },
        ),
        migrations.AddIndex(
            model_name='technologysubtype',
            index=models.Index(fields=['name'], name='technology__name_b82295_idx'),
        ),
        migrations.AlterUniqueTogether(
            name='technologysubtype',
            unique_together={('category', 'name')},
        ),
    ]
