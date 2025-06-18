
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from filtration.models import Debit
from datetime import datetime

DebitMutex = threading.Lock()
def DebitMonitor(debit: Debit):
    threading.Thread(
        name=f"debit_monitor#DebitMonitor thread {datetime.now()}",
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "debit",
            "monitored_object_value": debit,
            "name": "debitMonitor",
            "lock": DebitMutex
        }
    ).start()