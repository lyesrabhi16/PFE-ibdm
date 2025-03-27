from logs.logging import logger as logging
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from siroperie.models import Sucre

SucreMutex = threading.Lock()
def sucreMonitor(sucre: Sucre):
    threading.Thread(
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "sucre",
            "monitored_object_value": sucre,
            "name": "sucreMonitor",
            "lock": SucreMutex
        }
    ).start()