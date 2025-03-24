
from datetime import datetime
from api_v1.excel_helpers import generateExcelReport
from api_v1.utils import get_midnight_value
from utilite.models import Utilite
from django.template.loader import render_to_string

def rapport_utilite(email):
    now = datetime.now()
    utilite = get_midnight_value(Utilite)

    if (utilite is None):
        return "les données d'utilité ne sont pas disponible pour le "+now.strftime("%Y-%m-%d")

    interval = email.interval if email.interval != "manual" else f"{email.interval_manual} jours"
    data = {
        "date": utilite.date.strftime("%Y-%m-%d"),
        "rapport_name": "Utilite",
        "interval": interval,
        "header_codes": ["zone", "nom", "valuer", 'unite'],
        "suffixes": {
        },
        "headers": [
            {"title": "Zone", "code": "zone"},
            {"title": "Nom", "code": "nom"},
            {"title": "Valeur", "code": "valuer"},
            {"title": "Unité", "code": "unite"}
        ],
        "rows": [
            {
                "zone": "KRONES",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "Pression 7",
                "valuer": "{:.2f}".format((utilite.ut_kr_p7 or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_kr_p7 or 0) or 0) <= 6.5),
            },
            {
                "zone": "",
                "nom": "Pression Azote",
                "valuer": "{:.2f}".format((utilite.ut_kr_pn2 or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_kr_pn2 or 0) or 0) <= 6.5),
            },
            {
                "zone": "",
                "nom": "Pression 40",
                "valuer": "{:.2f}".format((utilite.ut_kr_p40 or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_kr_p40 or 0) or 0) <= 26),
            },
            {
                "zone": "",
                "nom": "Pression Chaudiere",
                "valuer": "{:.2f}".format((utilite.ut_kr_pv or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_kr_pv or 0) or 0) <= 6.5),
            },
            {
                "zone": "",
                "nom": "Pression Gaz",
                "valuer": "{:.2f}".format((utilite.ut_kr_pg or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_kr_pg or 0) or 0) <= 250),
            },
            {
                "zone": "",
                "nom": "Temperature Trane",
                "valuer": "{:.2f}".format((utilite.ut_kr_tt or 0)),
                "unite": "°C",
                "danger": bool(((utilite.ut_kr_tt or 0) or 0) >= 5),
            },
            {
                "zone": "",
                "nom": "Temperature Compresseur",
                "valuer": "{:.2f}".format((utilite.ut_kr_tc or 0)),
                "unite": "°C",
                "danger": bool(((utilite.ut_kr_tc or 0) or 0) >= 35),
            },
            {
                "zone": "SIDEL",
                "nom": "",
                "valuer": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "zone": "",
                "nom": "Pression 7",
                "valuer": "{:.2f}".format((utilite.ut_sid_p7 or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_sid_p7 or 0) or 0) <= 6.5),
            },
            {
                "zone": "",
                "nom": "Pression Azote",
                "valuer": "{:.2f}".format((utilite.ut_sid_pn2 or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_sid_pn2 or 0) or 0) <= 6.5),
            },
            {
                "zone": "",
                "nom": "Pression 40",
                "valuer": "{:.2f}".format((utilite.ut_sid_p40 or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_sid_p40 or 0) or 0) <= 26),
            },
            {
                "zone": "",
                "nom": "Pression Chaudiere",
                "valuer": "{:.2f}".format((utilite.ut_sid_pv or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_sid_pv or 0) or 0) <= 6.5),
            },
            {
                "zone": "",
                "nom": "Pression Gaz",
                "valuer": "{:.2f}".format((utilite.ut_sid_pg or 0)),
                "unite": "Bars",
                "danger": bool(((utilite.ut_sid_pg or 0) or 0) <= 250 ),
            },
            {
                "zone": "",
                "nom": "Temperature Trane",
                "valuer": "{:.2f}".format((utilite.ut_sid_tt or 0)),
                "unite": "°C",
                "danger": bool(((utilite.ut_sid_tt or 0) or 0) >= 5),
            },
            {
                "zone": "",
                "nom": "Temperature Compresseur",
                "valuer": "{:.2f}".format((utilite.ut_sid_tc or 0)),
                "unite": "°C",
                "danger": bool(((utilite.ut_sid_tc or 0) or 0) >= 35),
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

    filename = generateExcelReport(data, f"Utilite/Utilite - {utilite.date.strftime('%Y-%m-%d')}", f"Utilite-{utilite.date.strftime('%Y-%m-%d')}")
    return (render_to_string(
        template_name="emails/rapport.html",
        context=data
    ), filename, f"Rapport : Utilité - {utilite.date.strftime('%Y-%m-%d')}")