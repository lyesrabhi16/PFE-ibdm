import asyncio
import json
from multiprocessing import context
from urllib import request
from apscheduler.schedulers.twisted import TwistedScheduler
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from channels.db import database_sync_to_async

from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre

scheduler = TwistedScheduler()


def get_sucre_latest_data():
    return Sucre.objects.latest("date")

def broadcast_sucre():
    print("running broadcast_sucre")
    channel_layer = get_channel_layer()
    data = get_sucre_latest_data()
    print("data:", data)
    async_to_sync(channel_layer.group_send)(
        "sucre",
        {
            "type": "sucre.data",
            "data": SucreSerializer(data, context={ "request": None }).data,
        },
    )

scheduler.add_job(
    broadcast_sucre,
    "cron",
    second="*/1",
    id="broadcast_sucre",
)

scheduler.start()
