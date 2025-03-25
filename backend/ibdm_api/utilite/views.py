from datetime import datetime
from django.http import JsonResponse
from rest_framework import viewsets,permissions
from api_v1.utils import with_operation_ids
from api_v1.serializers import FeedMetaDataSerializer
from utilite.models import Co2Ifruit, Utilite
from drf_spectacular.utils import extend_schema, OpenApiParameter
from .serializers import Co2IfruitSerializer,UtiliteSerializer
from rest_framework.decorators import api_view, permission_classes

@extend_schema(tags=["Utilite"])
@with_operation_ids(
    on_list="getCo2IfruitList",
    on_retrieve="getCo2Ifruit",

)
class Co2IfruitViewset(viewsets.ReadOnlyModelViewSet):
    queryset = Co2Ifruit.objects.all()
    serializer_class = Co2IfruitSerializer
    permission_classes = [permissions.IsAuthenticated]


@extend_schema(tags=["Utilite"])
@with_operation_ids(
    on_list="getUtiliteList",
    on_retrieve="getUtilite",

)
class UtiliteViewset(viewsets.ReadOnlyModelViewSet):
    queryset = Utilite.objects.all()
    serializer_class = UtiliteSerializer
    permission_classes = [permissions.IsAuthenticated]



@extend_schema(
    tags=["Utilite"],
    summary="get Co2_Ifruit at specific time",
    operation_id="getCo2IfruitAtSpecificTime",
    request=None,
    responses={
        200: Co2IfruitSerializer,
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
def getCo2IfruitAtSpecificTime(request):
    """
    getCo2IfruitAtSpecificTime
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
    

    queryset = Co2Ifruit.objects.filter(**filters)
    record = queryset.first()

    if (record):
        return JsonResponse(Co2IfruitSerializer(record).data)
    else:
        return JsonResponse({}, status=404)




@extend_schema(
    tags=["Utilite"],
    summary="get utilite at specific time",
    operation_id="getUtiliteAtSpecificTime",
    request=None,
    responses={
        200: UtiliteSerializer,
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
def getUtiliteAtSpecificTime(request):
    """
    getUtiliteAtSpecificTime
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
    

    queryset = Utilite.objects.filter(**filters)
    record = queryset.first()

    if (record):
        return JsonResponse(UtiliteSerializer(record).data)
    else:
        return JsonResponse({}, status=404)

@extend_schema(
    tags=["Utilite"],
    summary="get utilite metadata",
    operation_id="getUtiliteMetaData",
    request=None,
    responses={
        200: FeedMetaDataSerializer,
    },
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getUtiliteMetaData(request):
    co2_ifruit_first = Co2Ifruit.objects.first()
    co2_ifruit_last = Co2Ifruit.objects.last()
    now = datetime.now()
    return JsonResponse(
        FeedMetaDataSerializer(
            {
                "start_date": co2_ifruit_first.date if co2_ifruit_first else now,
                "end_date": co2_ifruit_last.date if co2_ifruit_last else now,
            }
        ).data
    )