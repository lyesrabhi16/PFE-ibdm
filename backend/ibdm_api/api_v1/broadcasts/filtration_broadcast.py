from logs.logging import logger as logging
import time
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from api_v1.monitors.debit_monitor import DebitMonitor
from api_v1.monitors.niveau_monitor import NiveauMonitor
from api_v1.monitors.pres_cond_monitor import PresCondMonitor
from api_v1.monitors.volume_monitor import VolumeMonitor
from filtration.models import Debit, Niveau, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer
from api_v1.utils import get_or_none


def broadcast_filtration():
    start_func = time.time()
    channel_layer = get_channel_layer()

    start = time.time()
    niveau_latest = get_or_none( Niveau ,Niveau.objects.latest, args=("date",))
    if niveau_latest is None:
        logging.info(f"broadcast_filtration# broadcast_filtration: No Niveau data found in {time.time() - start} seconds")
        return
    #logging.info(f"latest niveau: {str(niveau_latest)}")
    #NiveauMonitor(niveau_latest)


    debit_latest = get_or_none( Debit, Debit.objects.latest, args=("date",))
    if debit_latest is None:
        logging.info(f"broadcast_filtration# No Debit data found in {time.time() - start} seconds")
        return 
    #logging.info(f"latest debit_latest: {str(debit_latest)}")
    #DebitMonitor(debit_latest)

    volume_latest = get_or_none( Volume, Volume.objects.latest, args=("date",))
    if volume_latest is None:
        logging.info(f"broadcast_filtration# No Volume data found in {time.time() - start} seconds")
        return 
    #logging.info(f"latest volume_latest: {str(volume_latest)}")
    #VolumeMonitor(volume_latest)

    pres_cond_latest = get_or_none( PresCond, PresCond.objects.latest, args=("date",))
    if pres_cond_latest is None:
        logging.info(f"broadcast_filtration# No PresCond data found in {time.time() - start} seconds")
        return 
    #logging.info(f"latest pres_cond_latest: {str(pres_cond_latest)}")
    #PresCondMonitor(pres_cond_latest)

    logging.info(f"broadcast_filtration# {niveau_latest.date} retrieved in {time.time() - start}")

    data = {
                "niveau": NiveauSerializer(niveau_latest).data,
                "debit": DebitSerializer(debit_latest).data,
                "pres_cond": PresCondSerializer(pres_cond_latest).data,
                "volume": VolumeSerializer(volume_latest).data,
            }

    async_to_sync(channel_layer.group_send)(
        "filtration",
        {
            "type": "filtration.data",
            "data": data,
        },
    )

    """ async_to_sync(channel_layer.group_send)(
        "broadcast",
        {
            "type": "broadcast.data",
            "data": {
                "type": "filtration",
                "data": data,
            },
        },
    ) """
    logging.info(f"broadcast_filtration# {niveau_latest.date} done in {time.time() - start_func}")