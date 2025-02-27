

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
        