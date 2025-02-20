from django.urls import include, path
from rest_framework import routers

from siroperie.views import SucreView, getSucreAtSpecificTime, getSucreMetaData




router = routers.DefaultRouter()

router.register(r'sucre', SucreView)


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', include(router.urls), name="Siroperie Api Root"),
    path("sucre/specific", getSucreAtSpecificTime, name="sucre-specific"),
    path("sucre/meta", getSucreMetaData, name="sucre-meta"),
    path("sucre/<str:pk>/", SucreView.as_view({"get": "retrieve"}), name="sucre-detail"),
]
