from logs.logging import logger as logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from api_v1.monitors.co2_ifruit_monitor import Co2IfruitMonitor
from api_v1.monitors.utilite_monitor import UtiliteMonitor
from utilite.serializers import Co2IfruitSerializer, UtiliteSerializer
from utilite.models import Co2Ifruit, Utilite
from api_v1.utils import get_or_none


def broadcast_utilite():
    start_func = time.time()
    channel_layer = get_channel_layer()

    start = time.time()
    co2_ifruit_latest = get_or_none( Co2Ifruit ,Co2Ifruit.objects.latest, args=("date",))
    if co2_ifruit_latest is None:
        logging.info(f"broadcast_utilite# No Co2Ifruit data found in {time.time() - start} seconds")
        return
    Co2IfruitMonitor(co2_ifruit_latest)

    utilite_latest = get_or_none(Utilite, Utilite.objects.latest, args=("date",))
    if utilite_latest is None:
        logging.info(f"broadcast_utilite# No Utilite data found in {time.time() - start} seconds")
        return
    UtiliteMonitor(utilite_latest)

    logging.info(f"broadcast_utilite# {co2_ifruit_latest.date} retrieved in {time.time() - start}")

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
    """ async_to_sync(channel_layer.group_send)(
        "broadcast",
        {
            "type": "broadcast.data",
            "data": {
                "type": "utilite",
                "data": data,
            },
        },
    ) """
    logging.info(f"broadcast_utilite# {co2_ifruit_latest.date} done in {time.time() - start_func}")