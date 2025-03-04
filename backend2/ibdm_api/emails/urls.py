from django.urls import include, path
from rest_framework import routers

from emails.views import AlertEamilViewset, EmailScheduleViewset, SentEamilViewset, getPossibleMonitorValuesAlertEmails

router = routers.DefaultRouter()

router.register(r'schedules', EmailScheduleViewset)
router.register(r'sent', SentEamilViewset)
router.register(r"alerts", AlertEamilViewset)
# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path("", include(router.urls), name="Emails Api Root"),
    path("monitored-values", getPossibleMonitorValuesAlertEmails, name="Get Possible Monitor Values"),
]
