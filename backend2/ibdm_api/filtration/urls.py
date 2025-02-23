from django.urls import include, path
from rest_framework import routers

from filtration.views import DebitViewSet, NiveauViewSet, PresCondViewSet, VolumeViewSet

router = routers.DefaultRouter()

router.register(r'niveau', NiveauViewSet)
router.register(r'debit', DebitViewSet)
router.register(r'pres-cond', PresCondViewSet)
router.register(r'volume', VolumeViewSet)


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path("", include(router.urls), name="Filtration Api Root"),
]
