import logging
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from api_v1.monitors.debit_monitor import DebitMonitor
from api_v1.monitors.niveau_monitor import NiveauMonitor
from api_v1.monitors.pres_cond_monitor import PresCondMonitor
from api_v1.monitors.volume_monitor import VolumeMonitor
from filtration.models import Debit, Niveau, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer


def broadcast_filtration():
    
    channel_layer = get_channel_layer()


    niveau_latest = Niveau.objects.latest("date")
    #logging.info(f"latest niveau: {str(niveau_latest)}")
    NiveauMonitor(niveau_latest)


    debit_latest = Debit.objects.latest("date")
    #logging.info(f"latest debit_latest: {str(debit_latest)}")
    DebitMonitor(debit_latest)

    volume_latest = Volume.objects.latest("date")
    #logging.info(f"latest volume_latest: {str(volume_latest)}")
    VolumeMonitor(volume_latest)

    pres_cond_latest = PresCond.objects.latest("date")
    #logging.info(f"latest pres_cond_latest: {str(pres_cond_latest)}")
    PresCondMonitor(pres_cond_latest)

    logging.info("broadcast_filtration done retrieving data and now broadcasting")

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