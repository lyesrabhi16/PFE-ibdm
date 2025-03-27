from copy import deepcopy
from django.http import JsonResponse
from logs.logging import logger as logging
from rest_framework import viewsets, permissions

from emails.serializers import AlertEmailSerializer, EmailScheduleSerializer, PossibleMonitorValuesAlertEmailsSerializer, SentEmailSerializer
from api_v1.utils import with_operation_ids
from emails.filters import CustomAlertFilter, SentEmailFilters
from api_v1.emails.emails_scheduler import sendEmail
from api_v1.constants import ErrorCodes
from api_v1.serializers import ErrorResponseSerializer, SuccessResponseSerializer
from .models import ALL_MONITORED_VALUES, AlertEmail, EmailSchedule, sentEmail
from drf_spectacular.utils import extend_schema, extend_schema_view, OpenApiParameter
from rest_framework.decorators import api_view, permission_classes
from rest_framework.filters import SearchFilter, OrderingFilter
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.parsers import JSONParser, FormParser, MultiPartParser
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
@extend_schema_view(
    list=extend_schema(summary="get schedules", description="Get all schedules", parameters=[
            OpenApiParameter(
                name="search",
                required=False,
                description="Search by rapport, scheduled_users__username, scheduled_users__email, scheduled_users__first_name, scheduled_users__last_name, scheduled_roles__group__name",
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="ordering",
                required=False,
                description="Order by rapport, interval_manual, temps_envoi",
                enum=["rapport", "interval_manual", "temps_envoi", "-rapport", "-interval_manual", "-temps_envoi"],
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="interval",
                required=False,
                description="Filter by interval",
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="rapport",
                required=False,
                description="Filter by rapport",
                location=OpenApiParameter.QUERY,
            )
    ]),
)
class EmailScheduleViewset(viewsets.ModelViewSet):
    queryset = EmailSchedule.objects.all()
    serializer_class = EmailScheduleSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [SearchFilter, OrderingFilter, DjangoFilterBackend]
    filterset_fields = ("interval", "rapport", )
    search_fields = ["rapport", "scheduled_users__username", "scheduled_users__email", "scheduled_users__first_name", "scheduled_users__last_name", "scheduled_roles__group__name"]
    ordering_fields = ["rapport", "interval_manual", "temps_envoi"]

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        data = deepcopy(request.data)
        data["temps_envoi"] = data["next_run_time"].split("T")[1]
        return self.run_update(instance, data, partial)
    def partial_update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        data = deepcopy(request.data)
        if (
            next_run_time := data.get("next_run_time", None)
            or instance.next_run_time
        ):
            data["temps_envoi"] = next_run_time.split("T")[1]
        return self.run_update(instance, data, partial)

    def run_update(self, instance, data, partial):
        serializer = self.get_serializer(instance, data=data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return JsonResponse(self.get_serializer(instance).data)

@extend_schema(
    tags=["emails"]
)

@extend_schema_view(
    list=extend_schema(summary="get sent emails", description="Get all sent emails", parameters=[
            OpenApiParameter(
                name="search",
                required=False,
                description="Search by receptionist__username, receptionist__email, receptionist__first_name, receptionist__last_name, schedule__rapport, alert__monitored_value",
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="ordering",
                required=False,
                description="Order by temps_envois, receptionist",
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="email_type",
                required=False,
                description="Filter by alert or schedule",
                location=OpenApiParameter.QUERY,
            ),
    ]),
)
@with_operation_ids(
    on_retrieve="getSentEmail",
    on_list="getSentEmails",
)
class SentEamilViewset(viewsets.ReadOnlyModelViewSet):
    queryset = sentEmail.objects.all().order_by("temps_envoi").reverse()
    serializer_class = SentEmailSerializer
    parser_classes = [JSONParser]
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [SearchFilter, OrderingFilter, DjangoFilterBackend]
    filterset_class = SentEmailFilters
    search_fields = [
        "receptionist__username",
        "receptionist__email",
        "receptionist__first_name",
        "receptionist__last_name",
        "schedule__rapport",
        "alert__alert__monitored_value",
    ]
    ordering_fields = [
        'temps_envoi',
        "receptionist",
    ]







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
@extend_schema_view(
    list=extend_schema(summary="get alerts", description="Get all alerts", parameters=[
            OpenApiParameter(
                name="search",
                required=False,
                description="Search by monitored_value, send_to_users__username, send_to_users__email, send_to_users__first_name, send_to_users__last_name, send_to_roles__group__name",
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="ordering",
                required=False,
                description="Order by monitored_value, danger_point, warning_point, danger_reminder_interval, warning_reminder_interval",
                enum=["monitored_value", "danger_point", "warning_point", "danger_reminder_interval", "warning_reminder_interval", "-monitored_value", "-danger_point", "-warning_point", "-danger_reminder_interval", "-warning_reminder_interval"],
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="tag",
                required=False,
                description="Filter by monitored value tag",
                location=OpenApiParameter.QUERY,
            ),
            OpenApiParameter(
                name="enabled",
                required=False,
                description="Filter by enabled",
                location=OpenApiParameter.QUERY,
            )
    ]),
)
class AlertEamilViewset(viewsets.ModelViewSet):
    queryset = AlertEmail.objects.all()
    serializer_class = AlertEmailSerializer
    filter_backends = [SearchFilter, OrderingFilter, DjangoFilterBackend]
    filterset_class = CustomAlertFilter
    search_fields = ["monitored_value", "send_to_users__username", "send_to_users__email", "send_to_users__first_name", "send_to_users__last_name", "send_to_roles__group__name"]
    ordering_fields = ["monitored_value", "danger_point", "warning_point", "danger_reminder_interval", "warning_reminder_interval"]
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

@extend_schema(
    tags=["emails"],
    operation_id="sendScheduledEmailNow",
    summary="Send scheduled email now",
    request=None,
    responses={200: SuccessResponseSerializer, 404: ErrorResponseSerializer, 500:ErrorResponseSerializer}
)
@api_view(["POST"])
@permission_classes([permissions.IsAuthenticated])
def sendScheduledEmailNow(request, email_schedule_id):
    logging.info(f"emailScheduler# request => send email with id: {email_schedule_id}")
    try:
        email = EmailSchedule.objects.get(pk=email_schedule_id)
        sendEmail(email, schedule_next=False)
        return JsonResponse(
            SuccessResponseSerializer({
                "status": "success",
                "message": "email sent",
            }).data,status=200
        )
    except EmailSchedule.DoesNotExist:
        return JsonResponse(ErrorResponseSerializer(
            {
                "status": "error",
                "code": ErrorCodes.NOT_FOUND.code,
            }
        ).data, status=ErrorCodes.NOT_FOUND.status_code)
    except Exception as e:
        return JsonResponse(ErrorResponseSerializer(
            {
                "status": "error",
                "code": ErrorCodes.SERVER_ERROR.code,
            }
        ).data, status=ErrorCodes.SERVER_ERROR.status_code)