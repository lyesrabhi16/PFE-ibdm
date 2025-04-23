# chat/routing.py
from django.urls import re_path

from . import consumers

broadcast_urlpatterns = [
    #re_path(r"ws/broadcast", consumers.broadcastConsumer.as_asgi()),
]