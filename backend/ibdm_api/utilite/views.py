from datetime import datetime, timedelta
from django.http import JsonResponse
from rest_framework import viewsets,permissions
from api_v1.utils import get_value_at, with_operation_ids
from api_v1.serializers import FeedMetaDataSerializer
from utilite.models import Co2Ifruit, Utilite
from drf_spectacular.utils import extend_schema, OpenApiParameter
from .serializers import Co2IfruitSerializer,UtiliteSerializer, Co2IfruitConsommationSerializer
from rest_framework.decorators import api_view, permission_classes
from django.utils.dateparse import parse_datetime
from api_v1.utils import filter_by_fetch_type
from .utils import get_co2_consommation
from api_v1.constants import ErrorCodes
from .serializers import Co2MultiMetaConsommationsSerializer


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






@extend_schema(
    tags=["Utilite"],
    summary="get all the utilite values between two dates",
    request=None,
    parameters=[
        OpenApiParameter(
            name="start_date",
            required=True,
            type=str,
            location="query",
        ),
        OpenApiParameter(
            name="end_date",
            required=True,
            type=str,
            location="query",
        ),OpenApiParameter(
                name="fetch_type",
                required=False,
                type=str,
                enum=["all", "seconds", "minutes", "hours", "days", "weeks", "months", "years"],
                location="query",
            ),
    ],
    responses={
        200: UtiliteSerializer,
    },
)
@with_operation_ids(
    on_list="getUtiliteBetweenDates"
)
class UtiliteListView(viewsets.ReadOnlyModelViewSet):
    queryset = Utilite.objects.all()
    serializer_class = UtiliteSerializer
    
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):

        start_date = self.request.query_params.get("start_date")
        end_date = self.request.query_params.get("end_date")
        fetch_type = self.request.query_params.get("fetch_type", "all")
        if start_date and end_date:
            try:
                start_date = parse_datetime(start_date)
                end_date = parse_datetime(end_date)
            except ValueError:
                return Utilite.objects.none()
            
            queryset = filter_by_fetch_type(Utilite, start_date, end_date, fetch_type)
            return queryset
        return Utilite.objects.none()

    def get_paginated_response(self, data):
        response = super().get_paginated_response(data)
        response.data["meta"] = {
            "start_date": self.request.query_params.get("start_date"),
            "end_date": self.request.query_params.get("end_date"),
        }
        return response



@extend_schema(
    tags=["Utilite"],
    summary="get all the co2 values between two dates",
    request=None,
    parameters=[
        OpenApiParameter(
            name="start_date",
            required=True,
            type=str,
            location="query",
        ),
        OpenApiParameter(
            name="end_date",
            required=True,
            type=str,
            location="query",
        ),
        OpenApiParameter(
                name="fetch_type",
                required=False,
                type=str,
                enum=["all", "seconds", "minutes", "hours", "days", "weeks", "months", "years"],
                location="query",
            ),
    ],
    responses={
        200: Co2IfruitSerializer,
    },
)
@with_operation_ids(
    on_list="getCO2BetweenDates"
)
class CO2ListView(viewsets.ReadOnlyModelViewSet):
    queryset = Co2Ifruit.objects.all()
    serializer_class = Co2IfruitSerializer
    
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):

        start_date = self.request.query_params.get("start_date")
        end_date = self.request.query_params.get("end_date")
        fetch_type = self.request.query_params.get("fetch_type", "all")
        if start_date and end_date:
            try:
                start_date = parse_datetime(start_date)
                end_date = parse_datetime(end_date)
            except ValueError:
                return Co2Ifruit.objects.none()
            
            queryset = filter_by_fetch_type(Co2Ifruit, start_date, end_date, fetch_type)
            return queryset
        return Co2Ifruit.objects.none()

    def get_paginated_response(self, data):
        response = super().get_paginated_response(data)
        response.data["meta"] = {
            "start_date": self.request.query_params.get("start_date"),
            "end_date": self.request.query_params.get("end_date"),
        }
        return response


@extend_schema(
    tags=["Utilite"],
    summary="get co2 consommation between dates",
    operation_id="getCo2ConsommationBetweenDates",
    request=None,
    responses={
        200: Co2MultiMetaConsommationsSerializer,
    },
    parameters=[
        OpenApiParameter(
            name="start_date",
            required=True,
            type=str,
            location="query",
        ),
        OpenApiParameter(
            name="end_date",
            required=True,
            type=str,
            location="query",
        ),
    ]
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getCo2ConsommationBetweenDates(request):
    """
    getCo2ConsommationBetweenDates
    """

    start_date = request.query_params.get("start_date")
    end_date = request.query_params.get("end_date")
    if start_date and end_date:
        try:
            start_date = parse_datetime(start_date)
            end_date = parse_datetime(end_date)
        except ValueError:
            return JsonResponse({
                "status": "error",
                "error": ErrorCodes.INVALID_DATE_FORMAT.code,
            }, status=ErrorCodes.INVALID_DATE_FORMAT.status_code)
        record = {}
        record["from_date"] = start_date
        record["to_date"] = end_date
        record["consommations"] = []    
        d = start_date
        while d <= end_date:
            from_date = datetime(d.year, d.month, d.day) - timedelta(days=1)
            to_date = datetime(d.year, d.month, d.day)
            record["consommations"].append(get_co2_consommation(from_date, to_date))
            d += timedelta(days=1)
        record["consommations"] = sorted(record["consommations"], key=lambda x: x["from_date"], reverse=True)
        print("record", record)
        return JsonResponse(Co2MultiMetaConsommationsSerializer(record).data)
    else:
        return JsonResponse({
            "status": "error",
            "error": ErrorCodes.NOT_FOUND.code,
        }, status=ErrorCodes.NOT_FOUND.status_code)
    