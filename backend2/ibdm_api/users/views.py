from django.contrib.auth.models import Group, Permission
from rest_framework import permissions, viewsets
from api_v1.utils import with_operation_ids
from drf_spectacular.utils import extend_schema, OpenApiParameter, extend_schema_view
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
import rest_framework.pagination
from users.models import SubordinateAndSuperior
from .models import Role, User
from .serializers import (
    GroupSerializer,
    RoleSerializer,
    SubordinateAndSuperiorSerializer,
    UserSerializer,
    PermissionSerializer,
)



@with_operation_ids(
    on_list="getUsers",
    on_create="addUser",
    on_retrieve="getUser",
    on_destroy="removeUser",
    on_update="updateUser",
    on_partial_update="partialUpdateUser",
)
@extend_schema(tags=["users"])
@extend_schema_view(
    list=extend_schema(summary="Get users", description="Get all users", parameters=[
        OpenApiParameter(
        name="search",
        required=False,
        description="Search by username, email, first_name, last_name",
        location=OpenApiParameter.QUERY,
    ),
    OpenApiParameter(
        name="ordering",
        required=False,
        description="Order by id, username, email, first_name, last_name, role",
        enum=["id", "username", "email", "first_name", "last_name", "role", "-id", "-username", "-email", "-first_name", "-last_name", "-role"],
        location=OpenApiParameter.QUERY,
    ),
    OpenApiParameter(
        name="role",
        required=False,
        description="Filter by role",
        location=OpenApiParameter.QUERY,
        
    )
    ]),
)
class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    filter_backends = [SearchFilter, OrderingFilter, DjangoFilterBackend]
    filterset_fields = ["role"]
    search_fields = ["username", "email", "first_name", "last_name"]
    ordering_fields = ["id","username", "email", "first_name", "last_name", "role"]
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        qs = super().get_queryset()

        if (self.request.user.is_superuser or self.request.user.is_admin):
            return qs
        
        sub_sup = SubordinateAndSuperior.objects.filter(superior=self.request.user)
        if sub_sup.exists():
            subordinates = [s.subordinate for s in sub_sup]
            qs = qs.filter(id__in=[u.id for u in subordinates])
        return qs
    

@with_operation_ids(
    on_list="getGroups",
    on_create="addGroup",
    on_retrieve="getGroup",
    on_destroy="removeGroup",
    on_update="updateGroup",
    on_partial_update="partialUpdateGroup",
)
@extend_schema(tags=["Roles"])
class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """

    queryset = Group.objects.all().order_by("name")
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]

@with_operation_ids(
    on_list="getRoles",
    on_create="addRole",
    on_retrieve="getRole",
    on_destroy="removeRole",
    on_update="updateRole",
    on_partial_update="partialUpdateRole",
)

@extend_schema(tags=["Roles"])
class RoleViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """
    queryset = Role.objects.all().order_by("group__name")
    serializer_class = RoleSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_extra_action_url_map(self):
        print("Extra action url map", super().get_extra_action_url_map())
        return super().get_extra_action_url_map()

@with_operation_ids(
    on_list="getPermissions",
    on_create="addPermission",
    on_retrieve="getPermission",
    on_destroy="removePermission",
    on_update="updatePermission",
    on_partial_update="partialUpdatePermission",
)
@extend_schema(tags=["Permissions"])
class PermissionViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """

    queryset = Permission.objects.all().order_by("name")
    serializer_class = PermissionSerializer
    permission_classes = [permissions.IsAuthenticated]

@with_operation_ids(
    on_list="getSubordinatesAndSuperiors",
    on_create="addSubordinateAndSuperior",
    on_retrieve="getSubordinateAndSuperior",
    on_destroy="removeSubordinateAndSuperior",
    on_update="updateSubordinateAndSuperior",
    on_partial_update="partialUpdateSubordinateAndSuperior",
)
class SubordinateAndSuperiorViewSet(viewsets.ModelViewSet):

    queryset = SubordinateAndSuperior.objects.all()
    serializer_class = SubordinateAndSuperiorSerializer
    permission_classes = [permissions.IsAuthenticated]