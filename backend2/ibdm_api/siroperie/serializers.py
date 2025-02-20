

from rest_framework import serializers

from siroperie.models import Sucre

class SucreSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sucre
        fields = [
            "url",
            "date",
            "t_s21",
            "t_s22",
            "t_s23",
            "t_s24",
            "t_s25",
            "a_t02",
            "a_t03",
            "a_t04",
            "a_t05",
            "a_t06",
        ]
class SucreMetaDataSerializer(serializers.Serializer):
    start_date = serializers.DateTimeField()
    end_date = serializers.DateTimeField()
