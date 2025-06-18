import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from filtration.models import Volume
from datetime import datetime

VolumeMutex = threading.Lock()
def VolumeMonitor(Volume: Volume):
    threading.Thread(
        name=f"volume_monitor#VolumeMonitor thread {datetime.now()}",
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "Volume",
            "monitored_object_value": Volume,
            "name": "VolumeMonitor",
            "lock": VolumeMutex
        }
    ).start()
