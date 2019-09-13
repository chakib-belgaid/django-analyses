# encoding: utf-8

"""
Tests for fullstack.views

author  : raphael@softosapiens.fr
created : 2019-09-11 20:37:15 CEST
"""

from model_mommy.recipe import Recipe

from django.test import TestCase
from django.urls import reverse

from . import models


class ListOfEvents:
    """Test information contained in list events page"""

    def test_page_contains_event_name_and_date(self):
        event = Recipe(models.Event).make()
        response = self.client.get(self.url)
        self.assertContains(response, event.name)
        self.assertContains(response, event.date)

    def test_page_contains_event_location(self):
        location = Recipe(models.Location).make()
        event = Recipe(models.Event, location=location).make()
        response = self.client.get(self.url)
        self.assertContains(response, location.name)

    def test_page_contains_event_attendee_count(self):
        employees = Recipe(models.Employee).make(_quantity=3)
        event = Recipe(models.Event, employees=employees).make()
        response = self.client.get(self.url)
        self.assertContains(response, "<td>3</td>")  # WARNING Fragile test


class TestNaiveListOfEvents(TestCase, ListOfEvents):
    """Test information contained in list events page (naive version)"""

    url = reverse("fullstack-naive-list-events")


class TestPrefetchListOfEvents(TestCase, ListOfEvents):
    """Test information contained in list events page (prefetch version)"""

    url = reverse("fullstack-prefetch-list-events")


class TestOpitmizedListOfEvents(TestCase, ListOfEvents):
    """Test information contained in list events page (optimized version)"""

    url = reverse("fullstack-optimized-list-events")


# eof
