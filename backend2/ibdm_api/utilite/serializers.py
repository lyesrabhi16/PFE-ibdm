from rest_framework import serializers

from utilite.models import Co2Ifruit, Utilite


class Co2IfruitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Co2Ifruit
        fields = "__all__"


class UtiliteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Utilite
        fields = "__all__"
        