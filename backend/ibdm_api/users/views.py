from django.contrib.auth.models import Group, Permission
from django.http import JsonResponse
from rest_framework import permissions, viewsets
from api_v1.utils import with_operation_ids
from drf_spectacular.utils import extend_schema, OpenApiParameter, extend_schema_view, OpenApiTypes
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from api_v1.constants import ErrorCodes
from rest_framework.parsers import JSONParser, FormParser, MultiPartParser
from rest_framework.request import Request
from users.models import SubordinateAndSuperior
from api_v1.serializers import ErrorResponseSerializer
from .models import Role, User
from .serializers import (
    GroupSerializer,
    RoleSerializer,
    SubordinateAndSuperiorSerializer,
    UserPermsSerializer,
    UserSerializer,
    PermissionSerializer,
    GetSubordinateAndSuperiorIdResponseSerializer,
)
from rest_framework.decorators import api_view, permission_classes
from logs.logging import logger as logging
from rest_framework import serializers
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
    parser_classes=[
        JSONParser,
        FormParser,
        MultiPartParser,
    ]
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

        # traverse the subordinate and superior relationship to get all subordinates of the user
        # and their subordinates
        # if the user has no subordinates, return an empty queryset
        def traverse_tree(user):
            sub_sup = SubordinateAndSuperior.objects.filter(superior=user)
            if sub_sup.exists():
                subordinates = {s.subordinate for s in sub_sup}
                for s in sub_sup:    
                  subordinates = subordinates.union(traverse_tree(s.subordinate))
                return subordinates
            return set()

        subordinates = traverse_tree(self.request.user)
        if len(subordinates) > 0:
            qs = qs.filter(id__in=[u.id for u in subordinates])
            return qs
        return qs.none()
    
    def check(self, serializer):
        if self.request.user.is_superuser or self.request.user.is_admin:
            return
        # check if the user can add a user with requested role
        managed_roles = self.request.user.role.managed_roles.all()
        can_add = any(
            serializer.validated_data['role'] == role.group.name
            for role in managed_roles
        )
        if not can_add :
            raise serializers.ValidationError({
                "role": f"You do not have permission to add with this role {serializer.validated_data['role']}."
            })
        
    def perform_create(self, serializer):
        self.check(serializer)
        return super().perform_create(serializer)
    def preform_save(self, serializer):
        self.check(serializer)
        return super().perform_create(serializer)

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
        logging.info("Extra action url map", super().get_extra_action_url_map())
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
@extend_schema(tags=["users"])
class SubordinateAndSuperiorViewSet(viewsets.ModelViewSet):

    queryset = SubordinateAndSuperior.objects.all()
    serializer_class = SubordinateAndSuperiorSerializer
    permission_classes = [permissions.IsAuthenticated]

@extend_schema(tags=["users"], operation_id="getSubordinateAndSuperiorId", responses={
    200: GetSubordinateAndSuperiorIdResponseSerializer,
    404: ErrorResponseSerializer,
})
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getSubordinateAndSuperiorId(request, subordinate, superior):
    """
    Get the id of the SubordinateAndSuperior object that links the current user to their superior
    """
    sub_sup = SubordinateAndSuperior.objects.filter(subordinate=subordinate, superior=superior)
    if sub_sup.exists():
        return JsonResponse({"id": sub_sup[0].pk})
    return JsonResponse(ErrorResponseSerializer({"status": "error", "code": ErrorCodes.NOT_FOUND.code}).data, status=ErrorCodes.NOT_FOUND.status_code)

@extend_schema(
    tags=["users"],
    operation_id="getAllUserPerms",
    responses={
        200: UserPermsSerializer,
    }
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getAllUserPerms(request: Request):
    perms = set()
    if request.user.is_superuser:
        perms = Permission.objects.all().values_list("codename", flat=True)
    else:
        user_perms = Permission.objects.filter(user=request.user).values_list("codename", flat=True)
        role_perms = Permission.objects.filter(group=request.user.role.group).values_list("codename", flat=True)
        perms = set().union(user_perms, role_perms)
    return JsonResponse(UserPermsSerializer({
        "perms": perms
    }).data, status=200)
