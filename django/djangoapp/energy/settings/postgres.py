# encoding: utf-8

"""
Django settings for energy project using postgresql on locahost.

author  : raphael@softosapiens.fr
created : 2019-09-11 20:22:13 CEST
"""

from .common import *


# Database
GLOBAL_VARS["logger"]="/logs/postgreslogger.csv"
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "postgres",
        "USER": "postgres",
        # "PASSWORD": "postgres",
        "HOST": "postgres-db",
        "PORT": "5432",
    }
}

# eof
