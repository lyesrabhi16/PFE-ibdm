
from datetime import datetime, timedelta
from api_v1.excel_helpers import generateExcelReport
from api_v1.utils import get_midnight_value
from utilite.models import Co2Ifruit
from django.template.loader import render_to_string
from utilite.views import get_co2_consommation

def rapport_co2(email):
    today = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    co2 = get_midnight_value(Co2Ifruit)
    co2_cons = get_co2_consommation(from_date=today - timedelta(days=1), to_date=today)

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
                "zone": "CONSOMMATION",
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
                "zone": "ENTREE",
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