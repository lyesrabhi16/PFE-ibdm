from datetime import datetime
from drf_spectacular.utils import extend_schema, OpenApiParameter
from filtration.models import Niveau, Debit, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer
from rest_framework import viewsets
from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes
from django.http import JsonResponse
from api_v1.utils import get_value_at, with_operation_ids
from api_v1.serializers import ErrorResponseSerializer, FeedMetaDataSerializer
from api_v1.constants import ErrorCodes
# Create your views here.
@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_list="getNiveaux",
    on_retrieve="getNiveau",

)
class NiveauViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Niveau.objects.all()
    serializer_class = NiveauSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_list="getDebits",
    on_retrieve="getDebit",

)
class DebitViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Debit.objects.all()
    serializer_class = DebitSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_list="getPresConds",
    on_retrieve="getPresCond",

)
class PresCondViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = PresCond.objects.all()
    serializer_class = PresCondSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_list="getVolumes",
    on_retrieve="getVolume",

)
class VolumeViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Volume.objects.all()
    serializer_class = VolumeSerializer
    permission_classes = [permissions.IsAuthenticated]


@extend_schema(
    tags=["filtration"],
    operation_id="getNiveauAtSpecificTime",
    request=None,
    responses={
        200: NiveauSerializer,
    },
    parameters=[
        OpenApiParameter(
            name="year",
            required=True,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="month",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="day",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="hour",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="minute",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="second",
            required=False,
            type=int,
            location="query",
        ),
    ]
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getNiveauAtSpecificTime(request):
    """
    getNiveauAtSpecificTime
    """
    year = int(request.query_params.get('year', None))
    month = int(request.query_params.get('month', "01"))
    day = int(request.query_params.get('day', "01"))
    hour = int(request.query_params.get('hour', "00"))
    minute = int(request.query_params.get('minute', "00"))
    second = int(request.query_params.get('second', "00"))

    date = datetime.now().replace(
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        second=second,
    )

    record = get_value_at(Niveau, date)

    if (record):
        return JsonResponse(NiveauSerializer(record).data)
    else:
        return JsonResponse({}, status=404)


@extend_schema(
    tags=["filtration"],
    operation_id="getDebitAtSpecificTime",
    request=None,
    responses={
        200: DebitSerializer,
    },
    parameters=[
        OpenApiParameter(
            name="year",
            required=True,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="month",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="day",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="hour",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="minute",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="second",
            required=False,
            type=int,
            location="query",
        ),
    ]
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getDebitAtSpecificTime(request):
    """
    getDebitAtSpecificTime
    """
    year = int(request.query_params.get('year', None))
    month = int(request.query_params.get('month', "01"))
    day = int(request.query_params.get('day', "01"))
    hour = int(request.query_params.get('hour', "00"))
    minute = int(request.query_params.get('minute', "00"))
    second = int(request.query_params.get('second', "00"))

    date = datetime.now().replace(
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        second=second,
    )

    record = get_value_at(Debit, date)

    if (record):
        return JsonResponse(DebitSerializer(record).data)
    else:
        return JsonResponse({}, status=404)


@extend_schema(
    tags=["filtration"],
    operation_id="getVolumeAtSpecificTime",
    request=None,
    responses={
        200: VolumeSerializer,
    },
    parameters=[
        OpenApiParameter(
            name="year",
            required=True,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="month",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="day",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="hour",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="minute",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="second",
            required=False,
            type=int,
            location="query",
        ),
    ]
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getVolumeAtSpecificTime(request):
    """
    getVolumeAtSpecificTime
    """
    year = int(request.query_params.get('year', None))
    month = int(request.query_params.get('month', "01"))
    day = int(request.query_params.get('day', "01"))
    hour = int(request.query_params.get('hour', "00"))
    minute = int(request.query_params.get('minute', "00"))
    second = int(request.query_params.get('second', "00"))

    date = datetime.now().replace(
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        second=second,
    )

    record = get_value_at(Volume, date)

    if (record):
        return JsonResponse(VolumeSerializer(record).data)
    else:
        return JsonResponse({}, status=404)



@extend_schema(
    tags=["filtration"],
    operation_id="getPresCondAtSpecificTime",
    request=None,
    responses={
        200: PresCondSerializer,
    },
    parameters=[
        OpenApiParameter(
            name="year",
            required=True,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="month",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="day",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="hour",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="minute",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="second",
            required=False,
            type=int,
            location="query",
        ),
    ]
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getPresCondAtSpecificTime(request):
    """
    getPresCondAtSpecificTime
    """
    year = int(request.query_params.get('year', None))
    month = int(request.query_params.get('month', "01"))
    day = int(request.query_params.get('day', "01"))
    hour = int(request.query_params.get('hour', "00"))
    minute = int(request.query_params.get('minute', "00"))
    second = int(request.query_params.get('second', "00"))

    date = datetime.now().replace(
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        second=second,
    )

    record = get_value_at(PresCond, date)

    if (record):
        return JsonResponse(PresCondSerializer(record).data)
    else:
        return JsonResponse({}, status=404)

@extend_schema(
    tags=["filtration"],
    operation_id="getFiltrationMetaData",
    request=None,
    responses={
        200: FeedMetaDataSerializer,
    },
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getFiltrationMetaData(request):
    niveau_first = Niveau.objects.first()
    niveau_last = Niveau.objects.last()

    if (niveau_first is None or niveau_last is None):
        return JsonResponse(
            ErrorResponseSerializer(
                {
                    "status": "error",
                    "error": ErrorCodes.NOT_FOUND.code,
                }
            ).data, status= ErrorCodes.NOT_FOUND.status_code
        )

    return JsonResponse(
        FeedMetaDataSerializer(
            {
                "start_date": niveau_first.date,
                "end_date": niveau_last.date,
            }
        ).data
    )