from rest_framework.authentication import SessionAuthentication
from django.utils.translation import gettext_lazy as _
from drf_spectacular.extensions import OpenApiAuthenticationExtension
from api_v1.env import Env, EnvModes
class MySessionAuthentication(SessionAuthentication):
    def authenticate(self, request):
        print("Authenticating with MySessionAuthentication", request)
        return super().authenticate(request)
    def enforce_csrf(self, request):
        print("Enforcing CSRF for MySessionAuthentication")
        if (Env.ENV_MODE == EnvModes.DEVELOPMENT):
            # dev purposes
            return None 
        #raise ValueError("CSRF Failed: %s" % request.headers)
        if "HTTP_REFERER" not in request.META:
            request.META["HTTP_REFERER"] = Env.CSRF_TRUSTED_ORIGINS[0] if len(Env.CSRF_TRUSTED_ORIGINS) > 0 else None
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
    
