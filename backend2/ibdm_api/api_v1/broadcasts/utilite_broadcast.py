import logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from api_v1.monitors.co2_ifruit_monitor import Co2IfruitMonitor
from api_v1.monitors.utilite_monitor import UtiliteMonitor
from utilite.serializers import Co2IfruitSerializer, UtiliteSerializer
from utilite.models import Co2Ifruit, Utilite


def broadcast_utilite():
    start_func = time.time()
    channel_layer = get_channel_layer()

    start = time.time()
    co2_ifruit_latest = Co2Ifruit.objects.latest("date")
    Co2IfruitMonitor(co2_ifruit_latest)


    utilite_latest = Utilite.objects.latest("date")
    UtiliteMonitor(utilite_latest)

    logging.info(f"broadcast_utilite: {co2_ifruit_latest.date} retrieved in {time.time() - start}")

    data = {
                "co2_ifruit": Co2IfruitSerializer(co2_ifruit_latest).data,
                "utilite": UtiliteSerializer(utilite_latest).data,
            }

    async_to_sync(channel_layer.group_send)(
        "utilite",
        {
            "type": "utilite.data",
            "data": data,
        },
    )
    logging.info(f"broadcast_utilite: {co2_ifruit_latest.date} done in {time.time() - start_func}")