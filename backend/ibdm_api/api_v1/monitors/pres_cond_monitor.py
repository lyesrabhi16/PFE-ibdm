import threading
from filtration.models import PresCond
from api_v1.monitors.generic_monitor import GenericMonitor
from datetime import datetime

PresCondMutex = threading.Lock()
def PresCondMonitor(Pres_Cond: PresCond):
    threading.Thread(
        name=f"pres_cond_monitor#PresCondMonitor thread {datetime.now()}",
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "Pres_Cond",
            "monitored_object_value": Pres_Cond,
            "name": "Pres_CondMonitor",
            "lock": PresCondMutex,

        }
    ).start()