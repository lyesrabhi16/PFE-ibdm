
import threading
from api_v1.monitors.generic_monitor import GenericMonitor
from utilite.models import Co2Ifruit

mutex = threading.Lock()
def Co2IfruitMonitor(co2_ifruit: Co2Ifruit):
    threading.Thread(
        target=GenericMonitor,
        kwargs={
            "monitored_value_tag": "co2_ifruit",
            "monitored_object_value": co2_ifruit,
            "name": "co2IfruitMonitor",
            "lock": mutex
        }
    ).start()