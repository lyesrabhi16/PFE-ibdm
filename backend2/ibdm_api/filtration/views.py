from drf_spectacular.utils import extend_schema
from filtration.models import Niveau, Debit, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer
from rest_framework import viewsets
from rest_framework import permissions

from api_v1.utils import with_operation_ids
# Create your views here.
@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_create= "addNiveau",
    on_list="getNiveaux",
    on_retrieve="getNiveau",
    on_destroy="destroyNiveau",
    on_update="updateNiveau",
    on_partial_update="partialUpdateNiveau"

)
class NiveauViewSet(viewsets.ModelViewSet):
    queryset = Niveau.objects.all()
    serializer_class = NiveauSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_create= "addDebit",
    on_list="getDebits",
    on_retrieve="getDebit",
    on_destroy="destroyDebit",
    on_update="updateDebit",
    on_partial_update="partialUpdateDebit"

)
class DebitViewSet(viewsets.ModelViewSet):
    queryset = Debit.objects.all()
    serializer_class = DebitSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_create= "addPresCond",
    on_list="getPresConds",
    on_retrieve="getPresCond",
    on_destroy="destroyPresCond",
    on_update="updatePresCond",
    on_partial_update="partialUpdatePresCond"

)
class PresCondViewSet(viewsets.ModelViewSet):
    queryset = PresCond.objects.all()
    serializer_class = PresCondSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["filtration"])
@with_operation_ids(
    on_create= "addVolume",
    on_list="getVolumes",
    on_retrieve="getVolume",
    on_destroy="destroyVolume",
    on_update="updateVolume",
    on_partial_update="partialUpdateVolume"

)
class VolumeViewSet(viewsets.ModelViewSet):
    queryset = Volume.objects.all()
    serializer_class = VolumeSerializer
    permission_classes = [permissions.IsAuthenticated]