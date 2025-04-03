from django.db import connection, connections
from logs.logging import logger as logging
import os
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render
from django.contrib.staticfiles import finders

from ibdm_api.settings import BASE_DIR
from drf_spectacular.utils import extend_schema
from drf_spectacular.types import OpenApiTypes
from rest_framework.decorators import api_view
from django.conf import settings
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
    responses={},
)
@api_view(["GET"])
def getServerStatus(request):

    db_cons_states = {}

    for key in connections.databases.keys():
        if key == "default":
            continue
        try:
            db_conn = connections[key]
            db_conn.cursor()
            db_cons_states[key] = "CONNECTED"
        except Exception as e:
            db_cons_states[key] = "DISCONNECTED"


    return JsonResponse(
        {
            "status": "on",
            "version": settings.VERSION,
            "env": settings.ENV_MODE,
            "debug": settings.DEBUG,
            "description": "Server is running",
            "databases": db_cons_states,
        },
        status=200,
    )

