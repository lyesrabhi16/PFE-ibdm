from rest_framework import serializers

from users.serializers import UserSerializer

class LoginRequestSerializer(serializers.Serializer):
    email = serializers.CharField()
    password = serializers.CharField()
    remember_me = serializers.BooleanField(default=False)

class LoginResponseSerializer(serializers.Serializer):
    status = serializers.CharField()
    user = UserSerializer()

class HasPermResponseSerializer(serializers.Serializer):
    has_perm = serializers.BooleanField()