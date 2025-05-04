"""
ASGI config for ibdm_api project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/5.0/howto/deployment/asgi/
"""

import os
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator
from channels.auth import AuthMiddlewareStack
from siroperie.routing import siroperie_urlpatterns
from filtration.routing import filtration_urlpatterns
from emails.routing import sent_emails_urlpatterns
from utilite.routing import utilite_urlpatterns
from api_v1.routing import broadcast_urlpatterns
from .routing import status_urlpatterns
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ibdm_api.settings')

django_asgi_app = get_asgi_application()

websocket_urlPatterns = [
    *siroperie_urlpatterns,
    *filtration_urlpatterns,
    *sent_emails_urlpatterns,
    *utilite_urlpatterns,
    *status_urlpatterns,
    *broadcast_urlpatterns,
]

application = ProtocolTypeRouter({
    "http": django_asgi_app,
    "websocket": AllowedHostsOriginValidator(
        AuthMiddlewareStack(
            URLRouter(
                websocket_urlPatterns
            )
        )
    ),
})
