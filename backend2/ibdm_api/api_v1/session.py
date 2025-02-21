from rest_framework.authentication import SessionAuthentication
from api_v1.env import Env, EnvModes
from django.utils.translation import gettext_lazy as _
from drf_spectacular.extensions import OpenApiAuthenticationExtension

class MySessionAuthentication(SessionAuthentication):
    def enforce_csrf(self, request):
        if (Env.ENV_MODE == EnvModes.DEVELOPMENT):
            # dev purposes
            return None 
        #raise ValueError("CSRF Failed: %s" % request.headers)
        if "HTTP_REFERER" not in request.META:
            request.META["HTTP_REFERER"] = "https://server.ibdm.local.ifri"
        try:
            super().enforce_csrf(request)
        except Exception as e:
            raise ValueError(f"CSRF Failed: {e}\n Request headers: {request.META}")
        

# scheme.py

class MySessionAuthenticationScheme(OpenApiAuthenticationExtension):
    target_class = 'api_v1.session.MySessionAuthentication'
    name = 'MySessionAuthentication'

    def get_security_definition(self, auto_schema):        
        return {
            'type': 'apiKey',
            'in': 'cookie',
            'name': 'sessionid',
            'description': _(
                'Session based authentication. Use the sessionid cookie to authenticate.'
            )
        }