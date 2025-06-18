from matplotlib.pylab import f
from logs.logging import logger as logging
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from utilite.models import ChambreFroide
from datetime import datetime

Mutex = threading.Lock()
def chambreFroideMonitor(chambre_froide: ChambreFroide):
    threading.Thread(
        name=f"chambre_froide_monitor#ChambreFroideMonitor thread {datetime.now()}",
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "sucre",
            "monitored_object_value": chambre_froide,
            "name": "sucreMonitor",
            "lock": Mutex
        }
    ).start()