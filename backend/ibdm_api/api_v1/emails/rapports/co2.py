
from datetime import datetime, timedelta
from typing import List
from api_v1.excel_helpers import generateExcelReport
from api_v1.utils import get_midnight_value, get_value_at
import threading
from utilite.models import Co2Ifruit
from django.template.loader import render_to_string
from utilite.views import get_co2_consommation

co2_cons_list = []
def loadCo2(date):
    global co2_list
    co2_cons = get_co2_consommation(from_date=date - timedelta(days=1), to_date=date) # TODO: optimize this
    co2_cons_list.append(co2_cons)


def rapport_co2(email):
    global co2_cons_list

    today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    co2 = get_midnight_value(Co2Ifruit)
    co2_cons = get_co2_consommation(from_date=today - timedelta(days=1), to_date=today)
    co2_cons_list = []
    threads = []
    
    for i in range(1, today.day):
        thread = threading.Thread(target=loadCo2, args=(datetime(year=today.year, month=today.month, day=i),))
        threads.append(thread)
        thread.start()
    for thread in threads:
        thread.join()

    cons_depuis_1er_v182 = 0
    cons_depuis_1er_v1833 = 0
    cons_depuis_1er_vcan35 = 0
    cons_depuis_1er_vkrv40 = 0
    cons_depuis_1er_ve = 0

    for co2_cons in co2_cons_list:
        cons_depuis_1er_v182 += co2_cons.get("ut_co2_v182", 0)
        cons_depuis_1er_v1833 += co2_cons.get("ut_co2_v1833", 0)
        cons_depuis_1er_vcan35 += co2_cons.get("ut_co2_vcan35", 0)
        cons_depuis_1er_vkrv40 += co2_cons.get("ut_co2_vkrv40", 0)
        cons_depuis_1er_ve += co2_cons.get("ut_co2_ve", 0)


    if (co2 is None):
        return "les données de co2 ne sont pas disponible pour le "+today.strftime("%Y-%m-%d")

    interval = email.interval if email.interval != "manual" else f"{email.interval_manual} jours"
    data = {
        "date": co2.date.strftime("%Y-%m-%d"),
        "rapport_name": "CO2",
        "interval": interval,
        "header_codes": ["zone", "nom", "valuer", 'unite'],
        "suffixes": {},
        "headers": [
            {"title": "Zone", "code": "zone"},
            {"title": "Nom", "code": "nom"},
            {"title": "Valeur", "code": "valuer"},
            {"title": "Unité", "code": "unite"},
        ],
        "rows": [
            {
                "zone": "NIVEAU",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "MGI",
                "valuer": "{:.2f}".format((co2.ut_co2_vc1 or 0)),
                "unite": "KG",
                "danger": ((co2.ut_co2_vc1 or 0) or 0) <= 20000,
            },
            {
                "zone": "",
                "nom": "CEVITAL",
                "valuer": "{:.2f}".format((co2.ut_co2_vc2 or 0)),
                "unite": "KG",
                "danger": ((co2.ut_co2_vc2 or 0) or 0) <= 20000,
            },
            {
                "zone": "",
                "nom": "N2",
                "valuer": "{:.2f}".format((co2.ut_n2_vn2 or 0)),
                "unite": "KG",
                "danger": ((co2.ut_n2_vn2 or 0) or 0) <= 1000,
            },
            {
                "zone": "PRESSION",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "MGI PC1",
                "valuer": "{:.2f}".format((co2.ut_co2_pc1 or 0)),
                "unite": "Bars",
                "danger": ((co2.ut_co2_pc1 or 0) or 0) <= 10,
            },
            {
                "zone": "",
                "nom": "CEVITAL PC2",
                "valuer": "{:.2f}".format((co2.ut_co2_pc2 or 0)),
                "unite": "Bars",
                "danger": ((co2.ut_co2_pc2 or 0) or 0) <= 10,
            },
            {
                "zone": "",
                "nom": "N2",
                "valuer": "{:.2f}".format((co2.ut_n2_pn2 or 0)),
                "unite": "Bars",
                "danger": ((co2.ut_n2_pn2 or 0) or 0) <= 10,
            },
            {
                "zone": "",
                "nom": "NOURISSSE",
                "valuer": "{:.2f}".format(((co2.ut_co2_pn ) or 0)),
                "unite": "Bars",
                "danger": ((co2.ut_co2_pn or 0) or 0) <= 10,
            },
            {
                "zone": "",
                "nom": "SOUDE",
                "valuer": "{:.2f}".format((co2.ut_soude or 0)),
                "unite": "Bars",
                "danger": ((co2.ut_soude or 0) or 0) <= 10,
            },
            {
                "zone": "CONSOMMATION DE LA JOURNEE PRECEDANTE",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "182",
                "valuer": "{:.2f}".format(co2_cons.get("ut_co2_v182", 0)),
                "unite": "KG",
                "danger": False,
            },
            {
                "zone": "",
                "nom": "1833",
                "valuer": "{:.2f}".format(co2_cons.get("ut_co2_v1833", 0)),
                "unite": "KG",
                "danger": False,
            },
            {
                "zone": "",
                "nom": "can35",
                "valuer": "{:.2f}".format(co2_cons.get("ut_co2_vcan35", 0)),
                "unite": "KG",
                "danger": False,
            },
            {
                "zone": "",
                "nom": "krv40",
                "valuer": "{:.2f}".format(co2_cons.get("ut_co2_vkrv40", 0)),
                "unite": "KG",
                "danger": False,
            },
            {
                "type": "CONSOMMATION DEPUIS LE 1er",
                "nom": "",
                "valeur": "",
                "unite": "",
                "fill": "",
                "danger": False,
                "highlight": True,
            },
            {
                "type": "",
                "nom": "182",
                "valeur": "{:.2f}".format(cons_depuis_1er_v182),
                "unite": "KG",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "1833",
                "valeur": "{:.2f}".format(cons_depuis_1er_v1833),
                "unite": "KG",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "can35",
                "valeur": "{:.2f}".format(cons_depuis_1er_vcan35),
                "unite": "KG",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "krv40",
                "valeur": "{:.2f}".format(cons_depuis_1er_vkrv40),
                "unite": "KG",
                "danger": False,
            },
            {
                "zone": "ENTREE DE LA JOURNEE PRECEDANTE",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "VE",
                "valuer": "{:.2f}".format(co2_cons.get("ut_co2_ve", 0)),
                "unite": "KG",
                "danger": False,
            },
            {
                "zone": "ENTREE DEPUIS LE 1er",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "VE",
                "valuer": "{:.2f}".format(cons_depuis_1er_ve),
                "unite": "KG",
                "danger": False,
            },
            {
                "zone": "",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
            },
        ],
    }

    filename = generateExcelReport(data, f"co2/CO2 - {co2.date.strftime('%Y-%m-%d')}", f"CO2-{co2.date.strftime('%Y-%m-%d')}")
    return (render_to_string(
        template_name="emails/rapport.html",
        context=data
    ), filename, f"Rapport : CO2 - {co2.date.strftime('%Y-%m-%d')}")