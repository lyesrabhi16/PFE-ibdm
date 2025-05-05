import threading
from datetime import datetime, timedelta
from .models import Volume
from api_v1.utils import get_value_at


def calculate_consommation_filtration(from_date, to_date):
    def loadVolume(date, volume_list):
        v = get_value_at(Volume, date)
        volume_list.append(v)

    volume_list = []
    threads = []
    d = from_date
    while d <= to_date:
        date = datetime(d.year, d.month, d.day)
        thread = threading.Thread(target=loadVolume, args=(date, volume_list))
        threads.append(thread)
        thread.start()

        d += timedelta(days=1)

    for thread in threads:
        thread.join()
        
    volume_forage = 0
    volume_total_eau_brute = 0
    volume_total_hytec = 0
    volume_total_osmotec = 0
    volume_total_osmosee = 0
    volume_contre_lavage = 0

    for volume in volume_list:
        volume_forage += volume.vol_for
        volume_total_eau_brute += (volume.vol_uf1 or 0) + (volume.vol_uf2 or 0) + (volume.vol_uf3 or 0) + (volume.vol_uf4 or 0) + (volume.vol_uf5 or 0) + (volume.vol_uf6 or 0)
        volume_total_hytec += (volume.vol_os1 or 0) + (volume.vol_os2 or 0) + (volume.vol_os3 or 0)
        volume_total_osmotec += (volume.vol_os4 or 0) + (volume.vol_os5 or 0) + (volume.vol_os6 or 0) + (volume.vol_os7 or 0) + (volume.vol_os8 or 0) + (volume.vol_os9 or 0)
        
        _volume_total_hytec = (volume.vol_os1 or 0) + (volume.vol_os2 or 0) + (volume.vol_os3 or 0)
        _volume_total_osmotec = (volume.vol_os4 or 0) + (volume.vol_os5 or 0) + (volume.vol_os6 or 0) + (volume.vol_os7 or 0) + (volume.vol_os8 or 0) + (volume.vol_os9 or 0)
    
        volume_total_osmosee += _volume_total_hytec + _volume_total_osmotec    

        volume_contre_lavage += (volume.vol_con_lav or 0)
    return {
        "forage": volume_forage,
        "eau_brute": volume_total_eau_brute,
        "hytec": volume_total_hytec,
        "osmotec": volume_total_osmotec,
        "osmosee": volume_total_osmosee,
        "contre_lavage": volume_contre_lavage,
    }
