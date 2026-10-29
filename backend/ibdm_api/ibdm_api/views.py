import json
from api_v1.utils import getServerStatusFromFile
from api_v1.constants import ErrorCodes
from logs.logging import logger as logging
import os
import subprocess
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render

from ibdm_api.settings import BASE_DIR
from drf_spectacular.utils import extend_schema
from drf_spectacular.types import OpenApiTypes
from rest_framework.decorators import api_view, permission_classes
from rest_framework import permissions

from django.conf import settings

from api_v1.permissions import IsSystemAdmin, admin_or_permission
from api_v1.serializers import ErrorResponseSerializer, SuccessResponseSerializer, SystemStatusSerializer
from api_v1.serializers import ServerConfigSerializer

def index(request):
    return render(request, "web/index.html")

@extend_schema(
    tags=["api"],
    summary="Get the CA certificate",
    operation_id="getCA",
    request=None,
    responses={(200, "application/x-x509-ca-cert"): OpenApiTypes.BINARY},
)
@api_view(["GET"])
def getCA(request):
    ca = os.path.join(BASE_DIR,"certs","ibdmCA.crt")
    if not os.path.exists(ca):
        logging.error(f"CA file not found: {ca}")
        return HttpResponse(status=404)
    return HttpResponse(
        open(ca,"rb"),
        content_type="application/x-x509-ca-cert",
        headers={
            'Content-Disposition': 'attachment; filename="ibdm_ca.crt"',
            'Cache-Control': 'no-cache',
        }
    )


@extend_schema(
    tags=["api"],
    summary="Get the server status",
    operation_id="getServerStatus",
    request=None,
    responses={
        200:SystemStatusSerializer
    },
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def getServerStatus(request):    
    try:
        status_data = getServerStatusFromFile()
        if status_data is not None:
            return JsonResponse(status_data, status=200)
        else:
            # If status file doesn't exist, return basic information
            return JsonResponse({
                "status": "on",
                "version": settings.VERSION,
                "env": settings.ENV_MODE,
                "debug": settings.DEBUG,
                "description": "Server is running, but detailed status is unavailable",
                "error": "Status data file not found"
            }, status=200)
    
    except Exception as e:
        # If there's an error reading the status file, return basic information
        logging.error(f"Error reading status file: {str(e)}")
        return JsonResponse({
            "status": "on",
            "version": settings.VERSION,
            "env": settings.ENV_MODE,
            "debug": settings.DEBUG,
            "description": "Server is running, but detailed status is unavailable",
            "error": str(e)
        }, status=200)

# the settings page is shown to users holding this permission, so the API accepts the same people (and admins)
ServerSettingsAccess = admin_or_permission("can_view_server_settings_page")

SERVICE_EXE = os.path.abspath(os.path.join(BASE_DIR, "..", "ibdm_service.exe"))  # constant: built from BASE_DIR only
SERVICE_RESTART_COMMAND = [SERVICE_EXE, "restart"]


@extend_schema(
    tags=["api"],
    summary="restart the server",
    operation_id="restartServer",
    request=None,
    responses=None,
)
@api_view(["GET"])
@permission_classes([IsSystemAdmin])
def restartServer(request):
    if not os.path.exists(SERVICE_EXE):
        return JsonResponse({"message": "Restart is only available when running as the Windows service"}, status=501)
    logging.info("Restarting server")
    # nosemgrep: python.lang.security.audit.dangerous-subprocess-use-audit
    # The command is a module constant (no request data), runs without a shell, and the view is admin-only.
    subprocess.Popen(SERVICE_RESTART_COMMAND, shell=False)
    return JsonResponse({"message": "OK"})


@extend_schema(
    tags=["api"],
    summary="set the server settings",
    operation_id="setServerConfig",
    request=ServerConfigSerializer,
    responses={
        200: SuccessResponseSerializer,
        500: ErrorResponseSerializer
    },
)
@api_view(["POST"])
@permission_classes([ServerSettingsAccess])
def setServerConfig(request):
    try:
        secret_key = request.data.get("SECRET_KEY", None)
        data = ServerConfigSerializer(request.data).data
        if secret_key is not None:
            data["SECRET_KEY"] = secret_key.strip()
        with open(settings.SETTINGS_JSON_FILE_PATH, "r") as f:
            existing_data = json.load(f)
            for key in data:
                if data.get(key) is not None:
                    existing_data[key] = data.get(key)
        with open(settings.SETTINGS_JSON_FILE_PATH, "w") as f:
            f.write(
                json.dumps(
                    existing_data,
                    indent=4,
                    default=str,
                )
            )
            return JsonResponse(
                SuccessResponseSerializer({
                    "status": "success",
                    "message": "server configuration has been set"
                }).data,
                status = 200,
            )
    except Exception as e:
        print(e)
        return JsonResponse(
            ErrorResponseSerializer(
                {
                    "status": "error",
                    "code": ErrorCodes.SERVER_ERROR.code,
                }
            ).data, status=ErrorCodes.SERVER_ERROR.status_code
        )



@extend_schema(
    tags=["api"],
    summary="get the server settings",
    operation_id="getServerConfig",
    request=None,
    responses={
        200: ServerConfigSerializer,
        500: ErrorResponseSerializer
    }
)
@api_view(["GET"])
@permission_classes([ServerSettingsAccess])
def getServerConfig(request):
    try:
        with open(settings.SETTINGS_JSON_FILE_PATH, "r") as f:
            json_data = json.load(f)
            json_data["SECRET_KEY"] = "CONFIDENTIAL"
            data = ServerConfigSerializer(json_data).data
        return JsonResponse(data,
            status = 200,
        )
    except Exception as e:
        print(e)
        return JsonResponse(
            ErrorResponseSerializer(
                {
                    "status": "error",
                    "code": ErrorCodes.SERVER_ERROR.code,
                }
            ).data, status=ErrorCodes.SERVER_ERROR.status_code
        )

