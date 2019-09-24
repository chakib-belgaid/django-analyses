# encoding: utf-8

"""
Django base settings for energy project.

author  : raphael@softosapiens.fr
created : 2019-09-11 20:22:13 CEST
"""

import os


BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = "efj2#g8rx99_+d*a8g!ko@xgl3qfve4#v8jus2!y@*gxw_8p^d"

DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = ["django.contrib.contenttypes", "energy.apps.fullstack"]

MIDDLEWARE = []

ROOT_URLCONF = "energy.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                # "django.template.context_processors.request",
            ]
        },
    }
]

WSGI_APPLICATION = "energy.wsgi.application"


# Internationalization

LANGUAGE_CODE = "en-us"
TIME_ZONE = "UTC"
USE_I18N = False
USE_L10N = False
USE_TZ = True


STATIC_URL = "/static/"

# eof
