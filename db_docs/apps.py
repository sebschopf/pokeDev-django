# db_docs/apps.py
from django.apps import AppConfig
from django.utils.translation import gettext_lazy as _

class DbDocsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'db_docs'
    verbose_name = _("Documentation BDD")
    

