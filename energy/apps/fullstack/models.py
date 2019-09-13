# encoding: utf-8

"""
Models for fullstack application

author  : raphael@softosapiens.fr
created : 2019-09-11 20:36:31 CEST
"""


from django.db import models


class Location(models.Model):
    """Represents a Location where an Event occurs"""

    name = models.CharField(max_length=64)

    class Meta:
        ordering = ["name"]
        verbose_name = "location"
        verbose_name_plural = "locations"

    def __str__(self):
        return "{s.name}".format(s=self)

    @classmethod
    def fetch(cls):
        return cls.objects.filter()


class Employee(models.Model):
    """Represents an Employee of the organisation"""

    name = models.CharField(max_length=64)

    class Meta:
        ordering = ["name"]
        verbose_name = "employee"
        verbose_name_plural = "employees"

    def __str__(self):
        return "{s.name}".format(s=self)

    @classmethod
    def fetch(cls):
        return cls.objects.filter()


class Event(models.Model):
    """Represents an Event to attend"""

    date = models.DateField()
    name = models.CharField(max_length=64)

    location = models.ForeignKey(Location, on_delete=models.CASCADE, null=True)
    employees = models.ManyToManyField(Employee)

    class Meta:
        ordering = ["date", "name"]
        verbose_name = "event"
        verbose_name_plural = "events"

    def __str__(self):
        return "{s.date} {s.name}".format(s=self)

    @classmethod
    def fetch(cls):
        return cls.objects.filter()

    @classmethod
    def fetch_optimized(cls):
        return (
            cls.objects.filter()
            .annotate(employee_count=models.Count("employees"))
            .annotate(location_name=models.F("location__name"))
        )


# eof
