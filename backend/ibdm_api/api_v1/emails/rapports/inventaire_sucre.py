
from datetime import datetime
import math
from api_v1.excel_helpers import generateExcelReport
from api_v1.utils import get_midnight_value
from siroperie.models import Sucre
from django.template.loader import render_to_string

def rapport_inventaire_sucre(interval=None, render_to_HTML_string=True, date=None, force_recreate_excel_file=False):
    now = datetime.now()
    sucre = get_midnight_value(Sucre, date=date) # if date is None it will use the current date

    if (sucre is None):
        return "les données de sucre ne sont pas disponible pour le "+now.strftime("%Y-%m-%d")

    total_tetra = (sucre.t_s21 or 0) + (sucre.t_s22 or 0) + (sucre.t_s23 or 0) + (sucre.t_s24 or 0) + (sucre.t_s25 or 0)
    total_adue = (sucre.a_t02 or 0) + (sucre.a_t03 or 0) + (sucre.a_t04 or 0) + (sucre.a_t05 or 0) + (sucre.a_t06 or 0)
    a_commander = math.floor((840000 - (total_tetra + total_adue)) / 20000)
    data = {
        "date": sucre.date.strftime("%Y-%m-%d"),
        "rapport_name": "Inventaire Du Sucre",
        "interval": interval,
        "synthese": (
            f"il faut commander {a_commander} { 'Citernes' if a_commander > 1 else 'Citerne'}"
            if a_commander > 0
            else "Pas de commande nécessaire"
        ),
        "header_codes": ["cuve", "inL", "inKG", "Fill"],
        "suffixes": {
            "cuve": "",
            "inL": "L",
            "inKG": "KG",
            "Fill": "%",
        },
        "headers": [
            {"title": "Cuve", "code": "cuve"},
            {"title": "Niveau L", "code": "inL", "suffix": "L"},
            {"title": "Niveau KG", "code": "inKG", "suffix": "KG"},
            {"title": "Fill", "code": "Fill", "suffix": "%"},
        ],
        "rows": [
            {
                "cuve": "ts21",
                "inL": "{:.2f}".format((sucre.t_s21 or 0)),
                "inKG": "{:.2f}".format((sucre.t_s21 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.t_s21 or 0) * 100 / 60000),
                "danger": bool(((sucre.t_s21 or 0) or 0) <= 6000),
            },
            {
                "cuve": "ts22",
                "inL": "{:.2f}".format((sucre.t_s22 or 0)),
                "inKG": "{:.2f}".format((sucre.t_s22 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.t_s22 or 0) * 100 / 60000),
                "danger": bool(((sucre.t_s22 or 0) or 0) <= 6000),
            },
            {
                "cuve": "ts23",
                "inL": "{:.2f}".format((sucre.t_s23 or 0)),
                "inKG": "{:.2f}".format((sucre.t_s23 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.t_s23 or 0) * 100 / 60000),
                "danger": bool(((sucre.t_s23 or 0) or 0) <= 6000),
            },
            {
                "cuve": "ts24",
                "inL": "{:.2f}".format((sucre.t_s24 or 0)),
                "inKG": "{:.2f}".format((sucre.t_s24 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.t_s24 or 0) * 100 / 60000),
                "danger": bool(((sucre.t_s24 or 0) or 0) <= 6000),
            },
            {
                "cuve": "ts25",
                "inL": "{:.2f}".format((sucre.t_s25 or 0)),
                "inKG": "{:.2f}".format((sucre.t_s25 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.t_s25 or 0) * 100 / 60000),
                "danger": bool(((sucre.t_s25 or 0) or 0) <= 6000),
            },
            {
                "cuve": "TOTAL TETRA",
                "inL": "{:.2f}".format(total_tetra),
                "inKG": "{:.2f}".format(total_tetra * 1.33),
                "Fill": "{:.2f}".format(total_tetra * 100 / 300000),
                "danger": True if total_tetra <= 30000 else False,
                "highlight": True,
            },
            {
                "cuve": "at02",
                "inL": "{:.2f}".format((sucre.a_t02 or 0)),
                "inKG": "{:.2f}".format((sucre.a_t02 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.a_t02 or 0) * 100 / 140000),
                "danger": (
                    True if ((sucre.a_t02 or 0) or 0) <= 14000 else False
                ),
            },
            {
                "cuve": "at03",
                "inL": "{:.2f}".format((sucre.a_t03 or 0)),
                "inKG": "{:.2f}".format((sucre.a_t03 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.a_t03 or 0) * 100 / 140000),
                "danger": (
                    True if ((sucre.a_t03 or 0) or 0) <= 14000 else False
                ),
            },
            {
                "cuve": "at04",
                "inL": "{:.2f}".format((sucre.a_t04 or 0)),
                "inKG": "{:.2f}".format((sucre.a_t04 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.a_t04 or 0) * 100 / 140000),
                "danger": (
                    True if ((sucre.a_t04 or 0) or 0) <= 14000 else False
                ),
            },
            {
                "cuve": "at05",
                "inL": "{:.2f}".format((sucre.a_t05 or 0)),
                "inKG": "{:.2f}".format((sucre.a_t05 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.a_t05 or 0) * 100 / 60000),
                "danger": True if ((sucre.a_t05 or 0) or 0) <= 6000 else False,
            },
            {
                "cuve": "at06",
                "inL": "{:.2f}".format((sucre.a_t06 or 0)),
                "inKG": "{:.2f}".format((sucre.a_t06 or 0) * 1.33),
                "Fill": "{:.2f}".format((sucre.a_t06 or 0) * 100 / 60000),
                "danger": True if ((sucre.a_t06 or 0) or 0) <= 6000 else False,
            },
            {
                "cuve": "TOTAL ADUE",
                "inL": "{:.2f}".format(total_adue),
                "inKG": "{:.2f}".format(total_adue * 1.33),
                "Fill": "{:.2f}".format(total_adue * 100 / 540000),
                "danger": True if total_adue <= 54000 else False,
                "highlight": True,
            },
            {
                "cuve": "TOTAL",
                "inL": "{:.2f}".format(total_tetra + total_adue),
                "inKG": "{:.2f}".format((total_tetra + total_adue) * 1.33),
                "Fill": "{:.2f}".format(
                    (total_tetra + total_adue) * 100 / 840000
                ),
                "highlight": True,
                "danger": (
                    True if (total_tetra + total_adue) <= 84000 else False
                ),
            },
        ],
    }

    filename = generateExcelReport(data, f"sucre/Inventaire Du Sucre - {sucre.date.strftime('%Y-%m-%d')}", f"Inventaire-Du-Sucre-{sucre.date.strftime('%Y-%m-%d')}", force=force_recreate_excel_file)
    return (
    render_to_string(
        template_name="emails/rapport.html",
        context=data
    ) if render_to_HTML_string else data, filename, f"Rapport : Inventaire Du Sucre - {sucre.date.strftime('%Y-%m-%d')}")