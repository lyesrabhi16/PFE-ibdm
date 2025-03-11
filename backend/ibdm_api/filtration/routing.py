# chat/routing.py
from django.urls import re_path

from . import consumers

filtration_urlpatterns = [
    re_path(r"ws/filtration", consumers.FiltrationConsumer.as_asgi()),
]