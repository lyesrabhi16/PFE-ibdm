from django.urls import include, path
from rest_framework import routers
from utilite.views import Co2IfruitViewset, UtiliteViewset, getCo2IfruitAtSpecificTime, getUtiliteAtSpecificTime, getUtiliteMetaData, getCo2IfruitConsommation, UtiliteListView, CO2ListView


router = routers.DefaultRouter()

router.register(r'co2_ifruit', Co2IfruitViewset)
router.register(r'utilite', UtiliteViewset)
# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path("", include(router.urls), name="Utilite Api Root"),
    path("co2_ifruit/specific", getCo2IfruitAtSpecificTime, name="getCo2IfruitAtSpecificTime"),
    path("co2_ifruit/consommation", getCo2IfruitConsommation, name="getCo2IfruitConsommation"),
    path("utilite/specific", getUtiliteAtSpecificTime, name="getUtiliteAtSpecificTime"),
    path("metadata", getUtiliteMetaData, name="getUtiliteMetadata"),
    path("co2_ifruit/list",  CO2ListView.as_view({"get": "list"}), name="co2_ifruit-start-end-list"),
    path("utilite/list", UtiliteListView.as_view({"get": "list"}), name="utilite-start-end-list"),

]
