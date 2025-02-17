from drf_spectacular.utils import extend_schema
from rest_framework import viewsets, generics
from rest_framework import permissions
from api_v1.utils import with_operation_ids
from siroperie.models import Sucre
from siroperie.serializers import SucreSerializer
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