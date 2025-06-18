from .sucre_monitor import sucreMonitor
from .chambre_froide_monitor import chambreFroideMonitor
from .co2_ifruit_monitor import Co2IfruitMonitor
from .debit_monitor  import DebitMonitor
from .niveau_monitor import NiveauMonitor
from .pres_cond_monitor import PresCondMonitor
from .utilite_monitor import UtiliteMonitor
from .volume_monitor import VolumeMonitor
from .system_monitor import system_monitor
from datetime import datetime
from siroperie.models import Sucre
from utilite.models import Co2Ifruit, ChambreFroide, Utilite
from filtration.models import Debit, Niveau, PresCond, Volume
from api_v1.utils import get_or_none
monitors = [
    {
        "name": "sucreMonitor",
        "model": Sucre,
        "monitor_function": sucreMonitor
    },
    {
        "name": "chambreFroideMonitor",
        "model": ChambreFroide,
        "monitor_function": chambreFroideMonitor
    },
    {
        "name": "Co2IfruitMonitor",
        "model": Co2Ifruit,
        "monitor_function": Co2IfruitMonitor
    },
    {
        "name": "DebitMonitor",
        "model": Debit,
        "monitor_function": DebitMonitor
    },
    {
        "name": "NiveauMonitor",
        "model": Niveau,
        "monitor_function": NiveauMonitor
    },
    {
        "name": "PresCondMonitor",
        "model": PresCond,
        "monitor_function": PresCondMonitor
    },
    {
        "name": "UtiliteMonitor",
        "model": Utilite,
        "monitor_function": UtiliteMonitor
    },
    {
        "name": "VolumeMonitor",
        "model": Volume,
        "monitor_function": VolumeMonitor
    },
    {
        "name": "system_monitor",
        "model": None,
        "monitor_function": system_monitor
    }
]

def monitor():
    now = datetime.now()
    for monitor in monitors:
        if monitor["model"] is not None:
            model = monitor["model"]
            latest = get_or_none( model, model.objects.latest, args=("date",))
            if latest is None:
                print(f"monitor#{monitor['name']} No data found for {monitor['model']} at {now}")
                continue
            monitor["monitor_function"](latest)
        else:
            monitor["monitor_function"]()
