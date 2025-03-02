from rest_framework import viewsets, permissions

from emails.serializers import AlertEmailSerializer, EmailScheduleSerializer, SentEmailSerializer
from api_v1.utils import with_operation_ids
from .models import AlertEmail, EmailSchedule, sentEmail
from drf_spectacular.utils import extend_schema
# Create your views here.
@with_operation_ids(
    on_create="addEmailSchedule",
    on_retrieve="getEmailSchedule",
    on_update="updateEmailSchedule",
    on_partial_update="partialUpdateEmailSchedule",
    on_destroy="destroyEmailSchedule",
    on_list="getEmailSchedules",
)
@extend_schema(
    tags=["emails"]
)
class EmailScheduleViewset(viewsets.ModelViewSet):
    queryset = EmailSchedule.objects.all()
    serializer_class = EmailScheduleSerializer
    permission_classes = [permissions.IsAuthenticated]

@with_operation_ids(
    on_retrieve="getSentEmail",
    on_list="getSentEmails",
)
@extend_schema(
    tags=["emails"]
)
class SentEamilViewset(viewsets.ReadOnlyModelViewSet):
    queryset = sentEmail.objects.all()
    serializer_class = SentEmailSerializer
    permission_classes = [permissions.IsAuthenticated]



@with_operation_ids(
    on_create="addAlertEmail",
    on_retrieve="getAlertEmail",
    on_update="updateAlertEmail",
    on_partial_update="partialUpdateAlertEmail",
    on_destroy="destroyAlertEmail",
    on_list="getAlertEmails",
)
@extend_schema(
    tags=["emails"]
)
class AlertEamilViewset(viewsets.ModelViewSet):
    queryset = AlertEmail.objects.all()  # noqa: F821
    serializer_class = AlertEmailSerializer
    permission_classes = [permissions.IsAuthenticated]


