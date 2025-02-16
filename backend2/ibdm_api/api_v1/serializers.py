from rest_framework import serializers

from api_v1.constants import ErrorCodes

class ErrorResponseSerializer(serializers.Serializer):
    status = serializers.CharField()
    code = serializers.ChoiceField(choices=ErrorCodes.getChoices())

class SuccessResponseSerializer(serializers.Serializer):
    status = serializers.CharField()
    message = serializers.CharField()