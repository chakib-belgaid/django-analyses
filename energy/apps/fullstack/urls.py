# encoding: utf-8

"""
Urls for fullstack application

author  : raphael@softosapiens.fr
created : 2019-09-11 20:50:56 CEST
"""


from django.urls import path

from . import views


urlpatterns = [
    path(r"events/naive/", views.naive_list_events, name="fullstack-naive-list-events"),
    path(
        r"events/prefetch/",
        views.prefetch_list_events,
        name="fullstack-prefetch-list-events",
    ),
    path(
        r"events/optimized/",
        views.optimized_list_events,
        name="fullstack-optimized-list-events",
    ),
]

# eof
