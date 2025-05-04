# chat/routing.py
from django.urls import re_path

from . import consumers

status_urlpatterns = [
    re_path(r"ws/status", consumers.StatusConsumer.as_asgi()),
]