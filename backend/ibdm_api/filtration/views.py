from datetime import datetime, timedelta
from drf_spectacular.utils import extend_schema, OpenApiParameter
from filtration.models import Niveau, Debit, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer
from rest_framework import viewsets
from rest_framework import permissions
from rest_framework.decorators import api_view, permission_classes
from django.http import JsonResponse
from api_v1.utils import get_value_at, with_operation_ids, filter_by_fetch_type
from api_v1.serializers import ErrorResponseSerializer, FeedMetaDataSerializer
from api_v1.constants import ErrorCodes
from django.utils.dateparse import parse_datetime
from filtration.utils import calculate_consommation_filtration
from filtration.serializers import FiltrationMetaConsommationSerializer, FiltrationMultiMetaConsommationsSerializer

# Create your views here.
@extend_schema(tags=["Filtration"])
@with_operation_ids(
    on_list="getNiveaux",
    on_retrieve="getNiveau",

)
class NiveauViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Niveau.objects.all()
    serializer_class = NiveauSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["Filtration"])
@with_operation_ids(
    on_list="getDebits",
    on_retrieve="getDebit",

)
class DebitViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Debit.objects.all()
    serializer_class = DebitSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["Filtration"])
@with_operation_ids(
    on_list="getPresConds",
    on_retrieve="getPresCond",

)
class PresCondViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = PresCond.objects.all()
    serializer_class = PresCondSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["Filtration"])
@with_operation_ids(
    on_list="getVolumes",
    on_retrieve="getVolume",

)
class VolumeViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Volume.objects.all()
    serializer_class = VolumeSerializer
    permission_classes = [permissions.IsAuthenticated]


@extend_schema(
    tags=["Filtration"],
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
    tags=["Filtration"],
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
    tags=["Filtration"],
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
    tags=["Filtration"],
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
    tags=["Filtration"],
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

@extend_schema(
    tags=["Filtration"],
    summary="get all the niveau values between two dates",
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
        200: NiveauSerializer,
    },
)
@with_operation_ids(
    on_list="getNiveauxBetweenDates"
)
class NiveauListView(viewsets.ReadOnlyModelViewSet):
    queryset = Niveau.objects.all()
    serializer_class = NiveauSerializer
    
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
                return Niveau.objects.none()
            
            queryset = filter_by_fetch_type(Niveau, start_date, end_date, fetch_type)
            return queryset
        return Niveau.objects.none()

    def get_paginated_response(self, data):
        response = super().get_paginated_response(data)
        response.data["meta"] = {
            "start_date": self.request.query_params.get("start_date"),
            "end_date": self.request.query_params.get("end_date"),
        }
        return response

@extend_schema(
    tags=["Filtration"],
    summary="get all the debit values between two dates",
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
        200: DebitSerializer,
    },
)

@with_operation_ids(
    on_list="getDebitsBetweenDates"
)
class DebitListView(viewsets.ReadOnlyModelViewSet):
    queryset = Debit.objects.all()
    serializer_class = DebitSerializer
    
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
                return Debit.objects.none()
            
            queryset = filter_by_fetch_type(Debit, start_date, end_date, fetch_type)
            return queryset
        return Debit.objects.none()

    def get_paginated_response(self, data):
        response = super().get_paginated_response(data)
        response.data["meta"] = {
            "start_date": self.request.query_params.get("start_date"),
            "end_date": self.request.query_params.get("end_date"),
        }
        return response

@extend_schema(
    tags=["Filtration"],
    summary="get all the volume values between two dates",
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
        200: VolumeSerializer,
    },
)
@with_operation_ids(
    on_list="getVolumesBetweenDates"
)
class VolumeListView(viewsets.ReadOnlyModelViewSet):
    queryset = Volume.objects.all()
    serializer_class = VolumeSerializer
    
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
                return Volume.objects.none()
            
            queryset = filter_by_fetch_type(Volume, start_date, end_date, fetch_type)
            return queryset
        return Volume.objects.none()

    def get_paginated_response(self, data):
        response = super().get_paginated_response(data)
        response.data["meta"] = {
            "start_date": self.request.query_params.get("start_date"),
            "end_date": self.request.query_params.get("end_date"),
        }
        return response

@extend_schema(
    tags=["Filtration"],
    summary="get all the pres_cond values between two dates",
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
        200: PresCondSerializer,
    },
)
@with_operation_ids(
    on_list="getPresCondsBetweenDates"
)
class PresCondListView(viewsets.ReadOnlyModelViewSet):
    queryset = PresCond.objects.all()
    serializer_class = PresCondSerializer
    
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
                return PresCond.objects.none()
            
            queryset = filter_by_fetch_type(PresCond, start_date, end_date, fetch_type)
            return queryset
        return PresCond.objects.none()

    def get_paginated_response(self, data):
        response = super().get_paginated_response(data)
        response.data["meta"] = {
            "start_date": self.request.query_params.get("start_date"),
            "end_date": self.request.query_params.get("end_date"),
        }
        return response




@extend_schema(
    tags=["Filtration"],
    summary="get filtration consommation",
    operation_id="getFiltrationConsommation",
    request=None,
    responses={
        200: FiltrationMetaConsommationSerializer,
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
def getFiltrationConsommation(request):
    """
    getFiltrationConsommation
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

    record = get_filtration_consommation(from_date, to_date)
    if (record):
        print("record", record)
        print("forage", record["consommation"]["forage"])
        return JsonResponse(FiltrationMetaConsommationSerializer(record).data)
    else:
        return JsonResponse({}, status=404)



def get_filtration_consommation(from_date, to_date):
    
    
    record = {}
    
    values = calculate_consommation_filtration(from_date, to_date)
    record["from_date"] = from_date
    record["to_date"] = to_date
    record["consommation"] = {
        "forage": values["forage"],
        "eau_brute": values["eau_brute"],
        "hytec": values["hytec"],
        "osmotec": values["osmotec"],
        "osmosee": values["osmosee"],
        "contre_lavage": values["contre_lavage"],
    }
    
    return record


@extend_schema(
    tags=["Filtration"],
    summary="get filtration consommation between dates",
    operation_id="getFiltrationConsommationBetweenDates",
    request=None,
    responses={
        200: FiltrationMultiMetaConsommationsSerializer,
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
def getFiltrationConsommationBetweenDates(request):
    """
    getFiltrationConsommationBetweenDates
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
            record["consommations"].append(get_filtration_consommation(d, d))
            d += timedelta(days=1)
        record["consommations"] = sorted(record["consommations"], key=lambda x: x["from_date"], reverse=True)
        print("record", record)
        print("forage", record["consommations"][0]["consommation"]["forage"])
        return JsonResponse(FiltrationMultiMetaConsommationsSerializer(record).data)
    else:
        return JsonResponse({
            "status": "error",
            "error": ErrorCodes.NOT_FOUND.code,
        }, status=ErrorCodes.NOT_FOUND.status_code)
    