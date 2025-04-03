from datetime import datetime
from django.http import JsonResponse
from rest_framework import viewsets,permissions
from api_v1.utils import get_value_at, with_operation_ids
from api_v1.serializers import FeedMetaDataSerializer
from utilite.models import Co2Ifruit, Utilite
from drf_spectacular.utils import extend_schema, OpenApiParameter
from .serializers import Co2IfruitSerializer,UtiliteSerializer, Co2IfruitConsommationSerializer
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
    year = int(request.query_params.get('year', None))
    month = int(request.query_params.get('month', "01"))
    day = int(request.query_params.get('day', "01"))
    hour = int(request.query_params.get('hour', "00"))
    minute = int(request.query_params.get('minute', "00"))
    second = int(request.query_params.get('second', "00"))

    date = datetime(
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        second=second,
    )
        

    record = get_value_at(Co2Ifruit, date)

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
    year = int(request.query_params.get('year', None))
    month = int(request.query_params.get('month', "01"))
    day = int(request.query_params.get('day', "01"))
    hour = int(request.query_params.get('hour', "00"))
    minute = int(request.query_params.get('minute', "00"))
    second = int(request.query_params.get('second', "00"))

    date = datetime(
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        second=second,
    )

    record = get_value_at(Utilite, date)

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





@extend_schema(
    tags=["Utilite"],
    summary="get co2_ifruit consommation",
    operation_id="getCo2IfruitConsommation",
    request=None,
    responses={
        200: Co2IfruitConsommationSerializer,
    },
    parameters=[
        OpenApiParameter(
            name="from_year",
            required=True,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="from_month",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="from_day",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="to_year",
            required=True,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="to_month",
            required=False,
            type=int,
            location="query",
        ),
        OpenApiParameter(
            name="to_day",
            required=False,
            type=int,
            location="query",
        ),
    ]
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getCo2IfruitConsommation(request):
    """
    getCo2IfruitConsommation
    """
    from_year = int(request.query_params.get('from_year', None))
    to_year = int(request.query_params.get('to_year', None))
    from_month = int(request.query_params.get('from_month', "01"))
    to_month = int(request.query_params.get('to_month', "01"))
    from_day = int(request.query_params.get('from_day', "01"))
    to_day = int(request.query_params.get('to_day', "01"))

    from_date = datetime(
        year=from_year,
        month=from_month,
        day=from_day,
    )

    to_date = datetime(
        year=to_year,
        month=to_month,
        day=to_day,
    )

    record = get_co2_consommation(from_date, to_date)
    if (record):
        return JsonResponse(Co2IfruitConsommationSerializer(record).data)
    else:
        return JsonResponse({}, status=404)


def get_co2_consommation(from_date, to_date):
    from_record = Co2IfruitSerializer(get_value_at(Co2Ifruit, from_date)).data
    to_record = Co2IfruitSerializer(get_value_at(Co2Ifruit, to_date)).data
    record = {}
    for key in from_record:
        try:
            record[key] = float(to_record[key]) - float(from_record[key])
        except Exception as e:
            record[key] = None
    record["from_date"] = from_date
    record["to_date"] = to_date
    record["from_value"] = from_record
    record["to_value"] = to_record
    record["date"] = to_date
    return record