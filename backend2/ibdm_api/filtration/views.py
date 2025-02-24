from drf_spectacular.utils import extend_schema, OpenApiParameter
from filtration.models import Niveau, Debit, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer
from rest_framework import viewsets
from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes
from django.http import JsonResponse
from api_v1.utils import with_operation_ids
from api_v1.serializers import FeedMetaDataSerializer
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
    year = request.query_params.get('year', None)
    month = request.query_params.get('month', "01")
    day = request.query_params.get('day', "01")
    hour = request.query_params.get('hour', "00")
    minute = request.query_params.get('minute', "00")
    second = request.query_params.get('second', "00")

    filters = {
        "date__year": year,
        "date__month": month,
        "date__day": day,
        "date__hour": hour,
        "date__minute": minute,
        "date__second": second
    }
    

    queryset = Niveau.objects.filter(**filters)
    record = queryset.first()

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
    year = request.query_params.get('year', None)
    month = request.query_params.get('month', "01")
    day = request.query_params.get('day', "01")
    hour = request.query_params.get('hour', "00")
    minute = request.query_params.get('minute', "00")
    second = request.query_params.get('second', "00")

    filters = {
        "date__year": year,
        "date__month": month,
        "date__day": day,
        "date__hour": hour,
        "date__minute": minute,
        "date__second": second
    }
    

    queryset = Debit.objects.filter(**filters)
    record = queryset.first()

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
    year = request.query_params.get('year', None)
    month = request.query_params.get('month', "01")
    day = request.query_params.get('day', "01")
    hour = request.query_params.get('hour', "00")
    minute = request.query_params.get('minute', "00")
    second = request.query_params.get('second', "00")

    filters = {
        "date__year": year,
        "date__month": month,
        "date__day": day,
        "date__hour": hour,
        "date__minute": minute,
        "date__second": second
    }
    

    queryset = Volume.objects.filter(**filters)
    record = queryset.first()

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
    year = request.query_params.get('year', None)
    month = request.query_params.get('month', "01")
    day = request.query_params.get('day', "01")
    hour = request.query_params.get('hour', "00")
    minute = request.query_params.get('minute', "00")
    second = request.query_params.get('second', "00")

    filters = {
        "date__year": year,
        "date__month": month,
        "date__day": day,
        "date__hour": hour,
        "date__minute": minute,
        "date__second": second
    }
    

    queryset = PresCond.objects.filter(**filters)
    record = queryset.first()

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

    return JsonResponse(
        FeedMetaDataSerializer(
            {
                "start_date": niveau_first.date,
                "end_date": niveau_last.date,
            }
        ).data
    )