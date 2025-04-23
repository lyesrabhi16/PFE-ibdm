from logs.logging import logger as logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from api_v1.utils import getServerStatusFromFile
from api_v1.serializers import SystemStatusSerializer



def broadcast_status():
    start_func = time.time()
    channel_layer = get_channel_layer()
    start = time.time()
    data = getServerStatusFromFile()
    if data is None:
        logging.info(f"broadcast_status# No data found in {time.time() - start} seconds")
        return
    logging.info(f"broadcast_status# {data} retrieved in {time.time() - start} seconds")
    #start_monitor= time.time()
    #sucreMonitor(data)
    #logging.info(f"broadcast_sucre# starting SucreMonitor {time.time() - start_monitor}")
    send_data = SystemStatusSerializer(data).data
    async_to_sync(channel_layer.group_send)(
        "status",
        {
            "type": "status.data",
            "data": send_data,
        },
    )
    """ async_to_sync(channel_layer.group_send)(
        "broadcast",
        {
            "type": "broadcast.data",
            "data": {
                "type": "status",
                "data": send_data,
            },
        },
    ) """
    logging.info(f"broadcast_status# {data} done in {time.time() - start_func}")