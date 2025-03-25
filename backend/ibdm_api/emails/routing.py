# chat/routing.py
from django.urls import re_path

from . import consumers

sent_emails_urlpatterns = [
    re_path(r"ws/emails/sent", consumers.SentEmailsConsumer.as_asgi()),
]