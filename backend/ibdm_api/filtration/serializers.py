

from filtration.models import Niveau, Debit, PresCond, Volume
from rest_framework import serializers

class NiveauSerializer(serializers.ModelSerializer):
    class Meta:
        model = Niveau
        fields = "__all__"

class DebitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Debit
        fields = "__all__"

class PresCondSerializer(serializers.ModelSerializer):
    class Meta:
        model = PresCond
        fields = "__all__"

class VolumeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Volume
        fields = "__all__"

class FiltrationConsommationSerializer(serializers.Serializer):
    forage = serializers.FloatField()
    eau_brute = serializers.FloatField()
    hytec = serializers.FloatField()
    osmotec = serializers.FloatField()
    osmosee = serializers.FloatField()
    contre_lavage = serializers.FloatField()
class FiltrationMetaConsommationSerializer(serializers.Serializer):
    from_date = serializers.DateTimeField()
    to_date = serializers.DateTimeField()
    consommation = FiltrationConsommationSerializer()

class FiltrationMultiMetaConsommationsSerializer(serializers.Serializer):
    from_date = serializers.DateTimeField()
    to_date = serializers.DateTimeField()
    consommations = FiltrationMetaConsommationSerializer(many=True)
    