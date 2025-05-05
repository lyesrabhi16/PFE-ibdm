from rest_framework import serializers
from drf_spectacular.utils import extend_schema_field

class ReportSerializer(serializers.Serializer):
    Rapport = serializers.CharField()
    Date = serializers.DateTimeField()
    Interval = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    col_names = serializers.ListField(child=serializers.CharField())
    data = serializers.ListField(child=serializers.DictField())
    synthese = serializers.CharField(required=False, allow_blank=True, allow_null=True)