from django.urls import include, path
from rest_framework import routers

from filtration.views import DebitViewSet, NiveauViewSet, PresCondViewSet, VolumeViewSet, getDebitAtSpecificTime, getFiltrationMetaData, getNiveauAtSpecificTime, getPresCondAtSpecificTime, getVolumeAtSpecificTime, NiveauListView, DebitListView, PresCondListView, VolumeListView

router = routers.DefaultRouter()

router.register(r'niveau', NiveauViewSet)
router.register(r'debit', DebitViewSet)
router.register(r'pres-cond', PresCondViewSet)
router.register(r'volume', VolumeViewSet)


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path("", include(router.urls), name="Filtration Api Root"),
    path("niveau/specific", getNiveauAtSpecificTime, name="getNiveauAtSpecificTime"),
    path("debit/specific", getDebitAtSpecificTime, name="getDebitAtSpecificTime"),
    path("pres-cond/specific", getPresCondAtSpecificTime, name="getPresCondAtSpecificTime"),
    path("volume/specific", getVolumeAtSpecificTime, name="getVolumeAtSpecificTime"),
    path("metadata", getFiltrationMetaData, name="getFiltrationMetadata"),
    path("niveau/list", NiveauListView.as_view({"get": "list"}), name="niveau-start-end-list"),
    path("debit/list", DebitListView.as_view({"get": "list"}), name="debit-start-end-list"),
    path("pres-cond/list", PresCondListView.as_view({"get": "list"}), name="pres-cond-start-end-list"),
    path("volume/list", VolumeListView.as_view({"get": "list"}), name="volume-start-end-list"),
]
