# encoding: utf-8

"""
Urls for energy project

author  : raphael@softosapiens.fr
created : 2019-09-11 20:49:39 CEST
"""


from django.urls import path
from django.urls import include

from .apps.fullstack import urls as fullstack_urls


urlpatterns = [path(r"fullstack/", include(fullstack_urls))]

# eof
