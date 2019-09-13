# encoding: utf-8

"""
Views for functions to perform energy consumption

author  : raphael@softosapiens.fr
created : 2019-09-11 20:37:53 CEST
"""


from django.urls import reverse

from django.shortcuts import get_object_or_404
from django.shortcuts import redirect
from django.shortcuts import render

from . import models


def naive_list_events(request):
    events = models.Event.fetch()
    return render(request, "fullstack/event/list.html", locals())


def prefetch_list_events(request):
    events = models.Event.fetch().prefetch_related("location", "employees")
    return render(request, "fullstack/event/list.html", locals())


def optimized_list_events(request):
    events = models.Event.fetch_optimized()
    return render(request, "fullstack/event/list-optimized.html", locals())


# eof
