from logs.logging import logger as logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from api_v1.monitors.sucre_monitor import sucreMonitor
from api_v1.utils import get_or_none
from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre



def broadcast_sucre():
    start_func = time.time()
    channel_layer = get_channel_layer()
    start = time.time()
    data = get_or_none( Sucre , Sucre.objects.latest, args=("date",))
    if data is None:
        logging.info(f"broadcast_sucre# No data found in {time.time() - start} seconds")
        return
    logging.info(f"broadcast_sucre# {data} retrieved in {time.time() - start} seconds")
    start_monitor= time.time()
    #sucreMonitor(data)
    logging.info(f"broadcast_sucre# starting SucreMonitor {time.time() - start_monitor}")
    send_data=SucreSerializer(data, context={ "request": None }).data
    async_to_sync(channel_layer.group_send)(
        "sucre",
        {
            "type": "sucre.data",
            "data": send_data,
        },
    )
    """ async_to_sync(channel_layer.group_send)(
        "broadcast",
        {
            "type": "broadcast.data",
            "data": {
                "type": "sucre",
                "data": send_data,
            },
        },
    ) """

    logging.info(f"broadcast_sucre# {data} done in {time.time() - start_func}")