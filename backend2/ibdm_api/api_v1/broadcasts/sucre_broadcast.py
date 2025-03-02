from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

from api_v1.monitors.sucre_monitor import sucreMonitor
from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre


def get_sucre_latest_data():
    return Sucre.objects.latest("date")

def broadcast_sucre():
    channel_layer = get_channel_layer()

    data = get_sucre_latest_data()
    print("data:", data)
    
    sucreMonitor(data)
    
    async_to_sync(channel_layer.group_send)(
        "sucre",
        {
            "type": "sucre.data",
            "data": SucreSerializer(data, context={ "request": None }).data,
        },
    )