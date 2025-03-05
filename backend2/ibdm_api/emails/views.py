import logging
from django.http import JsonResponse
from rest_framework import viewsets, permissions

from emails.serializers import AlertEmailSerializer, EmailScheduleSerializer, PossibleMonitorValuesAlertEmailsSerializer, SentEmailSerializer
from api_v1.utils import with_operation_ids
from .models import ALL_MONITORED_VALUES, AlertEmail, EmailSchedule, sentEmail
from drf_spectacular.utils import extend_schema
from rest_framework.decorators import api_view, permission_classes

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
    tags=["emails"],
)
class AlertEamilViewset(viewsets.ModelViewSet):
    queryset = AlertEmail.objects.all()
    serializer_class = AlertEmailSerializer
    permission_classes = [permissions.IsAuthenticated]



@extend_schema(
    tags=["emails"],
    operation_id="getPossibleMonitorValuesAlertEmails",
    summary="Get possible monitor values for alert emails",
    responses={200: PossibleMonitorValuesAlertEmailsSerializer}
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getPossibleMonitorValuesAlertEmails(request):
    all_values = set(map( lambda x: x[0] ,ALL_MONITORED_VALUES))
    monitored_values = set(AlertEmail.objects.all().values_list("monitored_value", flat=True))
    possible_values = all_values - monitored_values
    #logging.info(f"all_values: {all_values}")
    #logging.info(f"monitored_values: {monitored_values}")
    #logging.info(f"possible_values: {possible_values}")
    return JsonResponse(
        PossibleMonitorValuesAlertEmailsSerializer({
        "all_values": sorted(all_values),
        "monitored_values": sorted(monitored_values),
        "possible_values": sorted(possible_values)
    }).data
    )
