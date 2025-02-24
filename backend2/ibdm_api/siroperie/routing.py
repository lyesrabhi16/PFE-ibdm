# chat/routing.py
from django.urls import re_path

from . import consumers

siroperie_urlpatterns = [
    re_path(r"ws/sucre", consumers.SucreConsumer.as_asgi()),
]