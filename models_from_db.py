# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.BooleanField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.BooleanField()
    is_active = models.BooleanField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Corrections(models.Model):
    language = models.ForeignKey('Languages', models.DO_NOTHING)
    framework = models.TextField(blank=True, null=True)
    correction_text = models.TextField()
    status = models.TextField()
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    field = models.CharField(max_length=100, blank=True, null=True)
    suggestion = models.TextField(blank=True, null=True)
    user_id = models.UUIDField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'corrections'
        db_table_comment = 'table des corrections et des status'


class DbDocsChapter(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=200)
    slug = models.CharField(unique=True, max_length=50)
    order = models.IntegerField()
    description = models.TextField()

    class Meta:
        managed = False
        db_table = 'db_docs_chapter'


class DbDocsSection(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.CharField(max_length=200)
    content = models.TextField()
    sql_example = models.TextField()
    order = models.IntegerField()
    chapter = models.ForeignKey(DbDocsChapter, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'db_docs_section'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.SmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class LanguageProposals(models.Model):
    name = models.CharField(max_length=255)
    type = models.CharField(max_length=50, blank=True, null=True, db_comment='Type de proposition: language, tool, framework, library')
    description = models.TextField(blank=True, null=True)
    created_year = models.IntegerField(blank=True, null=True)
    creator = models.CharField(max_length=255, blank=True, null=True)
    used_for = models.TextField(blank=True, null=True)
    strengths = models.TextField(blank=True, null=True)  # This field type is a guess.
    popular_frameworks = models.TextField(blank=True, null=True)  # This field type is a guess.
    user_id = models.UUIDField(blank=True, null=True)
    status = models.CharField(max_length=50)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'language_proposals'


class LanguageUsage(models.Model):
    language = models.ForeignKey('Languages', models.DO_NOTHING, blank=True, null=True)
    category = models.ForeignKey('UsageCategories', models.DO_NOTHING, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'language_usage'
        unique_together = (('language', 'category'),)


class Languages(models.Model):
    name = models.CharField(unique=True, max_length=255)
    slug = models.CharField(unique=True, max_length=255)
    year_created = models.IntegerField(blank=True, null=True)
    creator = models.CharField(max_length=255, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    logo_path = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    type = models.CharField(max_length=50, blank=True, null=True)
    usage_rate = models.IntegerField(blank=True, null=True)
    is_open_source = models.BooleanField(blank=True, null=True)
    short_description = models.TextField(blank=True, null=True)
    used_for = models.TextField(blank=True, null=True)
    strengths = models.TextField(blank=True, null=True)  # This field type is a guess.
    popular_frameworks = models.TextField(blank=True, null=True)  # This field type is a guess.
    tools = models.JSONField(blank=True, null=True)
    logo_svg = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'languages'


class LanguagesFramework(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=100)
    slug = models.CharField(unique=True, max_length=50)
    description = models.TextField()
    website = models.CharField(max_length=200)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    language_id = models.BigIntegerField()

    class Meta:
        managed = False
        db_table = 'languages_framework'


class Libraries(models.Model):
    name = models.TextField()
    language = models.ForeignKey(Languages, models.DO_NOTHING, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    official_website = models.TextField(blank=True, null=True)
    github_url = models.TextField(blank=True, null=True)
    logo_path = models.TextField(blank=True, null=True)
    popularity = models.IntegerField(blank=True, null=True)
    is_open_source = models.BooleanField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    features = models.TextField(blank=True, null=True)  # This field type is a guess.
    unique_selling_point = models.TextField(blank=True, null=True)
    best_for = models.TextField(blank=True, null=True)
    used_for = models.TextField(blank=True, null=True)
    documentation_url = models.TextField(blank=True, null=True)
    version = models.TextField(blank=True, null=True)
    technology_type = models.CharField(max_length=50, blank=True, null=True)
    subtype = models.CharField(max_length=50, blank=True, null=True)
    slug = models.TextField(unique=True)
    license = models.TextField(blank=True, null=True)
    website_url = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'libraries'
        unique_together = (('name', 'language'), ('name', 'language'),)


class LibraryLanguageAssociations(models.Model):
    pk = models.CompositePrimaryKey('library_id', 'language_id')
    library = models.ForeignKey(Libraries, models.DO_NOTHING)
    language = models.ForeignKey(Languages, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'library_language_associations'


class LibraryLanguages(models.Model):
    library = models.ForeignKey(Libraries, models.DO_NOTHING)
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    primary_language = models.BooleanField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'library_languages'
        unique_together = (('library', 'language'),)
        db_table_comment = 'Table de jonction pour associer une bibliothÞque Ó plusieurs langages de programmation'


class Profiles(models.Model):
    id = models.UUIDField(primary_key=True)
    username = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)
    avatar_url = models.TextField(blank=True, null=True)
    full_name = models.TextField(blank=True, null=True)
    bio = models.TextField(blank=True, null=True)
    website = models.TextField(blank=True, null=True)
    user = models.OneToOneField(AuthUser, models.DO_NOTHING)
    role = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'profiles'


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


class StatsSearches(models.Model):
    id = models.BigAutoField(primary_key=True)
    search_term = models.TextField()
    user_id = models.UUIDField(blank=True, null=True)
    results_count = models.IntegerField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'stats_searches'


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


class TechnologyCategories(models.Model):
    type = models.CharField(unique=True, max_length=50)
    icon_name = models.CharField(max_length=50)
    color = models.CharField(max_length=50)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'technology_categories'


class TechnologySubtypes(models.Model):
    category = models.ForeignKey(TechnologyCategories, models.DO_NOTHING, blank=True, null=True)
    name = models.CharField(max_length=50)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'technology_subtypes'
        unique_together = (('category', 'name'),)


class TodoCategories(models.Model):
    name = models.TextField()
    color = models.TextField()
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'todo_categories'


class TodoStatus(models.Model):
    name = models.TextField()
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'todo_status'


class Todos(models.Model):
    title = models.TextField()
    description = models.TextField(blank=True, null=True)
    status = models.ForeignKey(TodoStatus, models.DO_NOTHING, blank=True, null=True)
    category = models.ForeignKey(TodoCategories, models.DO_NOTHING, blank=True, null=True)
    user_id = models.UUIDField(blank=True, null=True)
    is_completed = models.BooleanField(blank=True, null=True)
    due_date = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'todos'


class UsageCategories(models.Model):
    name = models.CharField(unique=True, max_length=255)
    created_at = models.DateTimeField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'usage_categories'


class UserLanguageLikes(models.Model):
    user_id = models.UUIDField()
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    created_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'user_language_likes'
        unique_together = (('user_id', 'language'),)


class UserRoles(models.Model):
    id = models.UUIDField(primary_key=True)
    role = models.TextField()  # This field type is a guess.
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'user_roles'


class Users(models.Model):
    id = models.UUIDField(primary_key=True)
    email = models.TextField(unique=True)
    role = models.TextField()
    name = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'users'


class UtilisateursCorrectioncomment(models.Model):
    id = models.BigAutoField(primary_key=True)
    content = models.TextField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    correction = models.ForeignKey(Corrections, models.DO_NOTHING)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'utilisateurs_correctioncomment'


class UtilisateursLanguageexpertise(models.Model):
    id = models.BigAutoField(primary_key=True)
    expertise_level = models.CharField(max_length=20)
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    language = models.ForeignKey(Languages, models.DO_NOTHING)
    user = models.ForeignKey(Profiles, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'utilisateurs_languageexpertise'
        unique_together = (('user', 'language'),)
