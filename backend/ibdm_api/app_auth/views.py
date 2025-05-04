from django.http import JsonResponse
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.decorators import permission_classes, api_view

from django.contrib.auth import authenticate, login, logout
from drf_spectacular.utils import extend_schema
from app_auth.serializers import HasPermResponseSerializer, LoginRequestSerializer, LoginResponseSerializer

from api_v1.constants import ErrorCodes
from api_v1.serializers import ErrorResponseSerializer, SuccessResponseSerializer
from users.models import User
from users.serializers import UserSerializer
# Create your views here.



@extend_schema(
    tags=["Authentication"],
    operation_id="login",
    request=LoginRequestSerializer,
    responses={
        200: LoginResponseSerializer,
        400: ErrorResponseSerializer,
        401: ErrorResponseSerializer,
    },
)
@api_view(["POST"])
@permission_classes([])
def login_view(request):
    serializer = LoginRequestSerializer(data=request.data)
    if not serializer.is_valid():
        return JsonResponse(ErrorResponseSerializer(
            {
                "status": "error",
                "code": ErrorCodes.INVALID_REQUEST.code,
            }
        ).data, status=ErrorCodes.INVALID_REQUEST.status_code)
    
    email = serializer.data.get('email')
    password = serializer.data.get('password')
    remember_me = serializer.data.get('remember_me')

    user = authenticate(request, email=email, password=password)
    if user is not None:
        login(request, user)
        serialized_data = LoginResponseSerializer(
            {
                "status": "success",
                "user": user,
            },
            context={'request': request}
        )
        if not remember_me:
            request.session.set_expiry(0)
        return Response(serialized_data.data)
    else:
        return JsonResponse(ErrorResponseSerializer({"status": "error", "code": ErrorCodes.INVALID_CREDENTIALS.code}).data, status=ErrorCodes.INVALID_CREDENTIALS.status_code)




@extend_schema(tags=["Authentication"],
               operation_id="logout",
               request=None,
               
               responses={
                   200: SuccessResponseSerializer,
               })
@api_view(["POST"])
@permission_classes([])
def logout_view(request):

    logout(request)
    return JsonResponse(
        SuccessResponseSerializer(
            {
                "status": "success",
                "message": "Successfully logged out."
            }
        ).data
    )

@extend_schema(tags=["Authentication"],
               operation_id="getCurrentUserInfo",
               responses={
                   200: UserSerializer,
               })
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def get_current_user_info(request):
    user = request.user
    return JsonResponse(
        UserSerializer(user, context={'request': request}).data
    )


@extend_schema(tags=["Authentication"],
               operation_id="hasPerm",
               responses={
                   200: HasPermResponseSerializer,
                   400: HasPermResponseSerializer,
               })
@api_view(["GET"])
@permission_classes([IsAuthenticated])
def connected_user_has_perm(request, codename):
    user : User = request.user
    _has_perm = user.has_perm(codename)
    return JsonResponse(
        HasPermResponseSerializer({
            "has_perm": _has_perm,
        }).data, status= 200 if _has_perm else 403
    )

