# encoding: utf-8

"""
Django settings for energy project using postgresql on locahost.

author  : raphael@softosapiens.fr
created : 2019-09-11 20:22:13 CEST
"""

from .common import *

DEBUG = True

# Database

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "energy",
        "USER": "energy",
        "PASSWORD": "energy",
        "HOST": "localhost",
        "PORT": "5432",
    }
}

# eof
