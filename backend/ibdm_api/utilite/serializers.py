from rest_framework import serializers

from utilite.models import Co2Ifruit, Utilite


class Co2IfruitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Co2Ifruit
        fields = "__all__"

class Co2IfruitConsommationSerializer(serializers.ModelSerializer):
    from_date = serializers.DateTimeField()
    to_date = serializers.DateTimeField()
    from_value = Co2IfruitSerializer()
    to_value = Co2IfruitSerializer()
    class Meta:
        model = Co2Ifruit
        fields = "__all__"


class UtiliteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Utilite
        fields = "__all__"

class Co2MultiMetaConsommationsSerializer(serializers.Serializer):
    from_date = serializers.DateTimeField()
    to_date = serializers.DateTimeField()
    consommations = Co2IfruitConsommationSerializer(many=True)