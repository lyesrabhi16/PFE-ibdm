from math import e
from django.contrib.auth.models import Permission, Group
from django.contrib.contenttypes.models import ContentType
from drf_spectacular.utils import extend_schema_field, extend_schema_serializer
from pkg_resources import require
from rest_framework import serializers

from users.models import SubordinateAndSuperior
from .models import Role, User, UserManager


class SuperiorsAndSubordinatesFieldsSerializerMixin():
    context = None

    @extend_schema_field({
        "type": "array",
        "items": {
            "$ref": "#/components/schemas/UserSerializerWithSubordinates"
        }
    })
    def get_subordinates(self, user:User):
        qs = SubordinateAndSuperior.objects.filter(
            superior=user
        ).select_related("subordinate")
        serialzer = UserSerializerWithSubordinates([item.subordinate for item in qs], many=True, context=self.context)
        return serialzer.data
    @extend_schema_field({
        "type": "array",
        "items": {
            "$ref": "#/components/schemas/UserSerializerWithSuperiors"
        }
    })
    def get_superiors(self, user:User):
        qs = SubordinateAndSuperior.objects.filter(
            subordinate=user
        ).select_related("superior")
        serialzer = UserSerializerWithSuperiors([item.superior for item in qs], many=True, context=self.context)
        return serialzer.data

@extend_schema_field(
    field={
        "type":"object",
        "properties":{
            "url": {"type": "string"},
            "group_id": {"type": "integer"},
            "name": {"type": "string"}
        },
        "required": ["url", "group_id", "name"]
    },
)
class GroupSerializer(serializers.ModelSerializer):
    group_id = serializers.IntegerField(source="id", read_only=True)
    class Meta:
        model = Group
        fields = ["url", "group_id","name"]
        extra_kwargs = {
            "url": {"read_only": True},
            "group_id": {"read_only": True},
        }
class PermissionSerializer(serializers.HyperlinkedModelSerializer):
    permission_id = serializers.IntegerField(source="id", read_only=True)
    content_type_name = serializers.StringRelatedField(
        source="content_type",
        read_only=True
    )
    content_type = serializers.PrimaryKeyRelatedField(
        queryset = ContentType.objects.all(),
        write_only=True,
    )
    class Meta:
        model = Permission
        fields = ["url", "permission_id","name", "codename", 'content_type', 'content_type_name']
        
class RoleSerializer(serializers.HyperlinkedModelSerializer):
    role_id = serializers.IntegerField(source="id", read_only=True)
    name = serializers.CharField(source="group__name", read_only=True)
    group_id = serializers.PrimaryKeyRelatedField(
        queryset=Group.objects.all(),
        source="group"  # The field name in the serializer is "group_id" instead of "group"
    )
    
    group = GroupSerializer(read_only=True)

    managed_roles = serializers.SlugRelatedField(slug_field="group__name", many=True, queryset=Role.objects.all())

    permissions = PermissionSerializer(many=True, source="group__permissions",read_only=True, default=[])
    class Meta:
        model = Role
        fields = ["url", "role_id","name", "group_id","group", "permissions", "managed_roles"]

class SubordinateAndSuperiorSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubordinateAndSuperior
        fields = ["url", "superior", "subordinate"]
class UserSerializerWithSubordinates(serializers.ModelSerializer, SuperiorsAndSubordinatesFieldsSerializerMixin):
    user_id = serializers.IntegerField(source="id", read_only=True)
    subordinates = serializers.SerializerMethodField()
    class Meta():
        model = User
        fields = [
            "url",
            "user_id",
            "email",
            "username",
            "subordinates",
        ]
        
class UserSerializerWithSuperiors(serializers.ModelSerializer, SuperiorsAndSubordinatesFieldsSerializerMixin):
    user_id = serializers.IntegerField(source="id", read_only=True)
    superiors = serializers.SerializerMethodField()
    class Meta():
        model = User
        fields = [
            "url",
            "user_id",
            "email",
            "username",
            "superiors",
        ]

class UserSerializer(serializers.ModelSerializer, SuperiorsAndSubordinatesFieldsSerializerMixin):
    user_id = serializers.IntegerField(source="id", read_only=True)
    avatar_url = serializers.ImageField(source="avatar", read_only=True, allow_null=True, required=False)
    role = serializers.SlugRelatedField(
        slug_field="group__name", queryset=Role.objects.all()
    )
    
    
    superiors = serializers.SerializerMethodField()
    
    subordinates = serializers.SerializerMethodField()
    @extend_schema_field(
            field=UserSerializerWithSuperiors,
    )
    def get_superiors(self, user: User):
        return super().get_superiors(user)
    @extend_schema_field(
            field=UserSerializerWithSubordinates,
    )
    def get_subordinates(self, user: User):
        return super().get_subordinates(user)

    def create(self, validated_data):
        return UserManager().create_user(**validated_data)

    def update(self, instance, validated_data):
        return UserManager().update_user(instance.id, **validated_data)

    class Meta:
        model = User
        fields = [
            "url",
            "user_id",
            "first_name",
            "last_name",
            "username",
            "email",
            "password",
            "phone_number",
            "avatar",
            "avatar_url",
            "role",
            "superiors",
            "subordinates",
            "user_permissions",
        ]
        extra_kwargs = {
            "url": {"read_only": True},
            "user_id": {"read_only": True},
            "password": {"write_only": True, "required": False},
            "avatar": {"write_only": True},
        }

