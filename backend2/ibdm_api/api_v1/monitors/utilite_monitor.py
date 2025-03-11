
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from utilite.models import Utilite

mutex = threading.Lock()
def UtiliteMonitor(utilite: Utilite):
    threading.Thread(
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "utilite",
            "monitored_object_value": utilite,
            "name": "utiliteMonitor",
            "lock": mutex
        }
    ).start()