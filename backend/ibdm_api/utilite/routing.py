# chat/routing.py
from django.urls import re_path

from . import consumers

utilite_urlpatterns = [
    re_path(r"ws/utilite", consumers.UtiliteConsumer.as_asgi()),
]