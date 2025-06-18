import threading

from api_v1.monitors.generic_monitor import GenericMonitor
from filtration.models import Niveau
from datetime import datetime

NiveauMutex = threading.Lock()
def NiveauMonitor(niveau: Niveau):
        threading.Thread(
            name=f"niveau_monitor#NiveauMonitor thread {datetime.now()}",
            target=GenericMonitor,
            kwargs={
                "monitored_value_tag": "niveau",
                "monitored_object_value": niveau,
                "name": "niveauMonitor",
                "lock": NiveauMutex
            }
        ).start()

