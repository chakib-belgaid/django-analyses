# encoding: utf-8

"""
Django settings for energy project using sqlite.

author  : raphael@softosapiens.fr
created : 2019-09-11 20:22:13 CEST
"""

from .common import *

DEBUG = True
# Database

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.path.join(BASE_DIR, "energy.sqlite3"),
    }
}

# eof
