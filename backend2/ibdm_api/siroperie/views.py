from math import e
from django.http import JsonResponse
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework import viewsets, generics
from rest_framework import permissions
from api_v1.utils import with_operation_ids
from siroperie.models import Sucre
from siroperie.serializers import SucreSerializer
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
def getAtSpecificTime(request):
    """
    getAtSpecificTime
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
    
    queryset = Sucre.objects.filter(**filters)
    record = queryset.first()
    if (record):
        return JsonResponse(SucreSerializer(record, context={ "request": request }).data)
    else:
        return JsonResponse({}, status=404)