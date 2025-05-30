
from drf_spectacular.views import SpectacularSwaggerView
from rest_framework import permissions
from api_v1.permissions import WithPermission

# Create your views here.
class CustomSwaggerView(SpectacularSwaggerView):
    """
    Custom Swagger View to render the Swagger UI.
    """
    permission_classes = [permissions.IsAuthenticated, WithPermission("can_view_documentation_page")]
    
class CustomRedocView(SpectacularSwaggerView):
    """
    Custom Redoc View to render the Redoc UI.
    """
    permission_classes = [permissions.IsAuthenticated, WithPermission("can_view_documentation_page")]
    