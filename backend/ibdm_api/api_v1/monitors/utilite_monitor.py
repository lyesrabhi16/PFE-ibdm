
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from utilite.models import Utilite
from datetime import datetime
mutex = threading.Lock()
def UtiliteMonitor(utilite: Utilite):
    threading.Thread(
        name=f"utilite_monitor#UtiliteMonitor thread {datetime.now()}",
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "utilite",
            "monitored_object_value": utilite,
            "name": "utiliteMonitor",
            "lock": mutex
        }
    ).start()