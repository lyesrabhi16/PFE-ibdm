import logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from api_v1.monitors.sucre_monitor import sucreMonitor
from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre


def get_sucre_latest_data():
    return Sucre.objects.latest("date")

def broadcast_sucre():
    start_func = time.time()
    channel_layer = get_channel_layer()
    start = time.time()
    data = get_sucre_latest_data()
    logging.info(f"broadcast_sucre: {data} retrieved in {time.time() - start} seconds")
    start_monitor= time.time()
    sucreMonitor(data)
    logging.info(f"broadcast_sucre: starting SucreMonitor {time.time() - start_monitor}")
    async_to_sync(channel_layer.group_send)(
        "sucre",
        {
            "type": "sucre.data",
            "data": SucreSerializer(data, context={ "request": None }).data,
        },
    )

    logging.info(f"broadcast_sucre: {data} done in {time.time() - start_func}")