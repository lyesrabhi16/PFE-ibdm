
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from filtration.models import Debit

DebitMutex = threading.Lock()
def DebitMonitor(debit: Debit):
    threading.Thread(
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "debit",
            "monitored_object_value": debit,
            "name": "debitMonitor",
            "lock": DebitMutex
        }
    ).start()