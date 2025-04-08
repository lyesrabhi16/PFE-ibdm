from api_v1.utils import getServerStatusFromFile
from logs.logging import logger as logging
import os
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render

from ibdm_api.settings import BASE_DIR
from drf_spectacular.utils import extend_schema
from drf_spectacular.types import OpenApiTypes
from rest_framework.decorators import api_view, permission_classes
from rest_framework import permissions

from django.conf import settings

from api_v1.serializers import SystemStatusSerializer

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
    ca = os.path.join(BASE_DIR,"certs","ifruit_CA.crt")
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



