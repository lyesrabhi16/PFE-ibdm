from apscheduler.schedulers.twisted import TwistedScheduler
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer

from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre

scheduler = TwistedScheduler()


def get_sucre_latest_data():
    return Sucre.objects.latest("date")

def broadcast_sucre():
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
    #minute="*/1", works
    second="*/10",
    id="broadcast_sucre",
)
scheduler.pause_job("broadcast_sucre")
def Manager():
    chennel_layer = get_channel_layer()
    sucre_broadcast_job =  scheduler.get_job("broadcast_sucre")
    if(len(chennel_layer.groups.get("sucre", [])) == 0 and sucre_broadcast_job.next_run_time is not None):
        print("manager stopping broadcast_sucre")
        scheduler.pause_job("broadcast_sucre")
    elif (len(chennel_layer.groups.get("sucre", [])) > 0 and sucre_broadcast_job.next_run_time is None):
        print("manager starting broadcast_sucre")
        scheduler.resume_job("broadcast_sucre")
        
scheduler.add_job(
    Manager,
    "interval",
    seconds=0.5,
    id="Manager",
    replace_existing=True,
)


scheduler.start()
