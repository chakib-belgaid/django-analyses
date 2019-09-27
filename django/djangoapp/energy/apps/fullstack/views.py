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
from energy.settings.common import GLOBAL_VARS
import pyRAPL 
import logging
import os 
logger = logging.getLogger(__name__)

# logger.setLevel(10)
if not os.path.exists(GLOBAL_VARS["logger"]):
    with open(GLOBAL_VARS["logger"],"w+") as mycsvfile : 
        mycsvfile.write("name,PKG,DRAM,TIME,AV_POWER\n")

def csv_handler(measures):
    with open(GLOBAL_VARS["logger"],"a+") as f :
        line =measures.data.copy()
        line["name"]= measures.function_name
        line["AV_POWER"]=measures.data["PKG"]/measures.data["TIME"]
        s=f"{line['name']},{line['PKG']},{line['DRAM']},{line['TIME']},{line['AV_POWER']}\n"
        f.write(s)

    # print("default handler")

@pyRAPL.measure(handler=csv_handler)
def naive_list_events(request):
    events = models.Event.fetch()
    print(events)
    return render(request, "fullstack/event/list.html", locals())

@pyRAPL.measure(handler=csv_handler)
def prefetch_list_events(request):
    events = models.Event.fetch().prefetch_related("location", "employees")
    return render(request, "fullstack/event/list.html", locals())

@pyRAPL.measure(handler=csv_handler)
def optimized_list_events(request):
    events = models.Event.fetch_optimized()
    return render(request, "fullstack/event/list-optimized.html", locals())


# eof
