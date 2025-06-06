# Generated by Django 5.2.1 on 2025-05-16 13:19

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='StatsLanguages',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('views_count', models.BigIntegerField(blank=True, null=True)),
                ('likes_count', models.BigIntegerField(blank=True, null=True)),
                ('shares_count', models.BigIntegerField(blank=True, null=True)),
                ('last_updated', models.DateTimeField(blank=True, null=True)),
            ],
            options={
                'db_table': 'stats_languages',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='StatsSearches',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('search_term', models.TextField()),
                ('user_id', models.UUIDField(blank=True, null=True)),
                ('results_count', models.IntegerField(blank=True, null=True)),
                ('created_at', models.DateTimeField(blank=True, null=True)),
            ],
            options={
                'db_table': 'stats_searches',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='StatsUsers',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('user_id', models.UUIDField()),
                ('contributions_count', models.BigIntegerField(blank=True, null=True)),
                ('corrections_count', models.BigIntegerField(blank=True, null=True)),
                ('proposals_count', models.BigIntegerField(blank=True, null=True)),
                ('last_activity', models.DateTimeField(blank=True, null=True)),
            ],
            options={
                'db_table': 'stats_users',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='StatsVisits',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('page_path', models.TextField()),
                ('user_id', models.UUIDField(blank=True, null=True)),
                ('referrer', models.TextField(blank=True, null=True)),
                ('user_agent', models.TextField(blank=True, null=True)),
                ('ip_address', models.TextField(blank=True, null=True)),
                ('created_at', models.DateTimeField(blank=True, null=True)),
                ('session_id', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'stats_visits',
                'managed': False,
            },
        ),
    ]
