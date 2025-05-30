from django.urls import path
from drf_spectacular.views import SpectacularAPIView, SpectacularRedocView, SpectacularSwaggerView
from .views import *
urlpatterns = [

    # YOUR PATTERNS
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    # Optional UI:
    path('', CustomSwaggerView.as_view(url_name='schema'), name='swagger-ui'), # default to swagger ui
    path('swagger-ui/', CustomSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('redoc/', CustomRedocView.as_view(url_name='schema'), name='redoc'),
]