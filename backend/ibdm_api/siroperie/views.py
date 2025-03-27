from datetime import datetime
from django.http import JsonResponse
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework import viewsets
from rest_framework import permissions
from api_v1.utils import get_value_at, with_operation_ids
from siroperie.models import Sucre
from siroperie.serializers import SucreSerializer
from api_v1.serializers import FeedMetaDataSerializer
from rest_framework.decorators import api_view, permission_classes
@extend_schema(
    tags=["Sucre"]
)
@with_operation_ids(
    on_list="getSucreList",
    on_retrieve="getSucre",
)
class SucreView(viewsets.ReadOnlyModelViewSet):
    queryset = Sucre.objects.all()
    serializer_class = SucreSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(
    tags=["Sucre"],
    operation_id="getSucreAtSpecificTime",
    request=None,
    responses={
        200: SucreSerializer,
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
def getSucreAtSpecificTime(request):
    """
    getSucreAtSpecificTime
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

    record = get_value_at(Sucre, date)

    if (record):
        return JsonResponse(SucreSerializer(record, context={ "request": request }).data)
    else:
        return JsonResponse({}, status=404)


@extend_schema(
    tags=["Sucre"],
    operation_id="getSucreMetaData",
    request=None,
    responses={
        200: FeedMetaDataSerializer,
    },
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getSucreMetaData(request):
    sucreFirst = Sucre.objects.first()
    sucreLast = Sucre.objects.last()

    if (not sucreFirst or not sucreLast):
        return JsonResponse({}, status=404)
    return JsonResponse(
        FeedMetaDataSerializer({
            "start_date": sucreFirst.date,
            "end_date": sucreLast.date
        }).data
    )

