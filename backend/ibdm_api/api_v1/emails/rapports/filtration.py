from datetime import datetime
import json
from typing import List
from api_v1.excel_helpers import generateExcelReport
from django.template.loader import render_to_string

from filtration.models import Debit, Niveau, PresCond, Volume
import threading

from api_v1.utils import get_midnight_value, get_value_at, print_log
from filtration.utils import calculate_consommation_filtration
from logs.logging import logger as logging

niveau : Niveau|None = None
volume : Volume|None = None
debit  : Debit|None= None
pres_cond : PresCond|None = None


def loadNiveau(date=None):
    global niveau
    niveau = get_midnight_value(Niveau, date)

def loadVolume(date=None):
    global volume
    volume = get_midnight_value(Volume, date)
        
def loadDebit(date=None):
    global debit
    debit = get_midnight_value(Debit, date)

def loadPresCond(date=None):
    global pres_cond
    pres_cond = get_midnight_value(PresCond, date)



def rapport_filtration(interval = None, render_to_HTML_string=True, date=None, force_recreate_excel_file=False):
    global niveau
    global volume
    global debit
    global pres_cond
    global dates
    global volume_list

    volume_list = []
    dates = []
    now = datetime.now()
    _date = now if date is None else date
    
    thread_n = threading.Thread(target=loadNiveau, args=(_date,))
    thread_v = threading.Thread(target=loadVolume, args=(_date,))
    thread_d = threading.Thread(target=loadDebit, args=(_date,))
    thread_p = threading.Thread(target=loadPresCond, args=(_date,))
    
    thread_n.start()
    thread_v.start()
    thread_d.start()
    thread_p.start()
    print_log("FILTRATION", "threads started")
    
    thread_n.join()
    thread_v.join()
    thread_d.join()
    thread_p.join()
    print_log("FILTRATION", "threads finished")
    
    if (niveau is None or volume is None or debit is None or pres_cond is None):
        return "les données nécessaire ne sont pas disponible pour le "+_date.strftime("%Y-%m-%d")


    def calculateCond():
        if (niveau is None or volume is None or debit is None or pres_cond is None):
            raise ValueError("les données nécessaire ne sont pas disponible pour le "+_date.strftime("%Y-%m-%d"))
         
        d_os1 = debit.d_os1 or 0
        d_os2 = debit.d_os2 or 0
        d_os3 = debit.d_os3 or 0
        c_os1 = pres_cond.c_os1 or 0
        c_os2 = pres_cond.c_os2 or 0
        c_os3 = pres_cond.c_os3 or 0
        
        cond_calculer = 0

        try:
            cond_calculer = (c_os1*d_os1/10+c_os2*d_os2/10+c_os3*d_os3/10)/(d_os1/10+d_os2/10+d_os3/10)    
        except Exception as e:
            # Handle any errors in calculation
            logging.info(f"Error calculating cond_calculer: {e}")
            cond_calculer = 0
        return cond_calculer

    # niveau
    FILL_F1 =  (niveau.niv_f1 or 0) * 100 / 450
    FILL_F2 =  (niveau.niv_f2 or 0) * 100 / 450
    FILL_UF1 = (niveau.niv_uf1 or 0) * 100 / 520
    FILL_UF2 = (niveau.niv_uf2 or 0) * 100 / 520
    FILL_OS1 = (niveau.niv_os1 or 0) * 100 / 60
    FILL_OS2 = (niveau.niv_os2 or 0) * 100 / 60
    FILL_OS3 = (niveau.niv_os3 or 0) * 100 / 60
    FILL_OS4 = (niveau.niv_os4 or 0) * 100 / 180
    FILL_OS5 = (niveau.niv_os5 or 0) * 100 / 45
    FILL_OS6 = (niveau.niv_os6 or 0) * 100 / 45
    FILL_OS7 = (niveau.niv_os7 or 0) * 100 / 10
    # conductivité
    cond_calculer = calculateCond()
    # consommation
    volume_total_eau_brute = (volume.vol_uf1 or 0) + (volume.vol_uf2 or 0) + (volume.vol_uf3 or 0) + (volume.vol_uf4 or 0) + (volume.vol_uf5 or 0) + (volume.vol_uf6 or 0)
    volume_total_hytec = (volume.vol_os1 or 0) + (volume.vol_os2 or 0) + (volume.vol_os3 or 0)
    volume_total_osmotec = (volume.vol_os4 or 0) + (volume.vol_os5 or 0) + (volume.vol_os6 or 0) + (volume.vol_os7 or 0) + (volume.vol_os8 or 0) + (volume.vol_os9 or 0)
    volume_total_osmosee = volume_total_hytec + volume_total_osmotec
    value_contre_lavage = (volume.vol_con_lav or 0)

    # consomation depuis le 1er forage
    le_1er = _date.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    cons_depuis_1er  = calculate_consommation_filtration(le_1er, _date)
    cons_depuis_1er_forage = cons_depuis_1er["forage"]
    cons_depuis_1er_volume_total_eau_brute = cons_depuis_1er["eau_brute"]
    cons_depuis_1er_volume_total_hytec = cons_depuis_1er["hytec"]
    cons_depuis_1er_volume_total_osmotec = cons_depuis_1er["osmotec"]
    cons_depuis_1er_volume_total_osmosee = cons_depuis_1er["osmosee"]
    cons_contre_lavage_depuis_1er = cons_depuis_1er["contre_lavage"]
    
    data = {
        "date": niveau.date.strftime("%Y-%m-%d"),
        "rapport_name": "Filtration",
        "interval": interval,
        "header_codes": ["type", "nom", "valeur", "unite", "fill"],
        "suffixes": {},
        "headers": [
            {"title": "Type", "code": "type"},
            {"title": "Nom", "code": "nom"},
            {"title": "Valeur", "code": "valeur"},
            {"title": "Unité", "code": "unite"},
            {"title": "Fill", "code": "fill"},
        ],
        "rows": [
            {
                "type": "NIVEAU",
                "nom": "",
                "valeur": "",
                "fill": "",
                "unite": "",
                "danger": False,
                "highlight": True,
            },
            {
                "type": "",
                "nom": "F1",
                "valeur": "{:.2f}".format((niveau.niv_f1 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_F1),
                "danger": FILL_F1 <= 50,
            },
            {
                "type": "",
                "nom": "F2",
                "valeur": "{:.2f}".format((niveau.niv_f2 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_F2),
                "danger": FILL_F2 <= 50,
            },
            {
                "type": "",
                "nom": "UF1",
                "valeur": "{:.2f}".format((niveau.niv_uf1 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_UF1),
                "danger": FILL_UF1 <= 50,
            },
            {
                "type": "",
                "nom": "UF2",
                "valeur": "{:.2f}".format((niveau.niv_uf2 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_UF2),
                "danger": FILL_UF2 <= 50,
            },
            {
                "type": "",
                "nom": "OS1",
                "valeur": "{:.2f}".format((niveau.niv_os1 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS1),
                "danger": FILL_OS1 <= 50,
            },
            {
                "type": "",
                "nom": "OS2",
                "valeur": "{:.2f}".format((niveau.niv_os2 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS2),
                "danger": FILL_OS2 <= 50,
            },
            {
                "type": "",
                "nom": "OS3",
                "valeur": "{:.2f}".format((niveau.niv_os3 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS3),
                "danger": FILL_OS3 <= 50,
            },
            {
                "type": "",
                "nom": "OS4",
                "valeur": "{:.2f}".format((niveau.niv_os4 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS4),
                "danger": FILL_OS4 <= 50,
            },
            {
                "type": "",
                "nom": "OS5",
                "valeur": "{:.2f}".format((niveau.niv_os5 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS5),
                "danger": FILL_OS5 <= 50,
            },
            {
                "type": "",
                "nom": "OS6",
                "valeur": "{:.2f}".format((niveau.niv_os6 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS6),
                "danger": FILL_OS6 <= 50,
            },
            {
                "type": "",
                "nom": "OS7",
                "valeur": "{:.2f}".format((niveau.niv_os7 or 0)),
                "unite": "M3",
                "fill": "{:.2f} %".format(FILL_OS7),
                "danger": FILL_OS7 <= 50,
            },
            {
                "type": "CONSOMMATION DE LA JOURNEE PRECEDANTE",
                "nom": "",
                "valeur": "",
                "unite": "",
                "fill": "",
                "danger": False,
                "highlight": True,
            },
            {
                "type": "",
                "nom": "Forage",
                "valeur": "{:.2f}".format((volume.vol_for or 0)),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Eau Brute",
                "valeur": "{:.2f}".format(volume_total_eau_brute),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Hytec",
                "valeur": "{:.2f}".format(volume_total_hytec),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Osmotec",
                "valeur": "{:.2f}".format(volume_total_osmotec),
                "unite": "M3",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Osmosée",
                "valeur": "{:.2f}".format(volume_total_osmosee),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Contre Lavage",
                "valeur": "{:.2f}".format(value_contre_lavage),
                "unite": "M3",
                "fill": "",
                "danger": True,

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
                "nom": "Forage",
                "valeur": "{:.2f}".format(cons_depuis_1er_forage),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Eau Brute",
                "valeur": "{:.2f}".format(cons_depuis_1er_volume_total_eau_brute),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Hytec",
                "valeur": "{:.2f}".format(cons_depuis_1er_volume_total_hytec),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Osmotec",
                "valeur": "{:.2f}".format(cons_depuis_1er_volume_total_osmotec),
                "unite": "M3",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Osmosée",
                "valeur": "{:.2f}".format(cons_depuis_1er_volume_total_osmosee),
                "unite": "M3",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "Contre Lavage",
                "valeur": "{:.2f}".format(cons_contre_lavage_depuis_1er),
                "unite": "M3",
                "fill": "",
                "danger": True,

            },
            {
                "type": "CONDUCTIVITE",
                "nom": "",
                "valeur": "",
                "unite": "",
                "danger": False,
                "fill": "",
                "highlight": True,
            },
            {
                "type": "",
                "nom": "UF",
                "valeur": "{:.2f}".format((pres_cond.c_uf or 0)),
                "unite": "µS",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "mesuré",
                "valeur": "{:.2f}".format((pres_cond.c_ose or 0)),
                "unite": "µS",
                "fill": "",
                "danger": False,
            },
            {
                "type": "",
                "nom": "calculé",
                "valeur": "{:.2f}".format((cond_calculer or 0)),
                "unite": "µS",
                "fill": "",
                "danger": False,
            },
            {
                "type": "PRESSION",
                "nom": "",
                "valeur": "",
                "unite": "",
                "fill": "",
                "danger": False,
                "highlight": True,
            },
            {
                "type": "",
                "nom": "OSE1",
                "valeur": "{:.2f}".format((pres_cond.p_ose1 or 0)),
                "unite": "Bars",
                "fill": "",
                "danger": bool(((pres_cond.p_ose1 or 0) or 0) <= 2),
            },
            {
                "type": "",
                "nom": "OSE2",
                "valeur": "{:.2f}".format((pres_cond.p_ose2 or 0)),
                "unite": "Bars",
                "fill": "",
                "danger": bool(((pres_cond.p_ose2 or 0) or 0) <= 2),
            },
            {
                "type": "",
                "nom": "Concentra",
                "valeur": "{:.2f}".format((pres_cond.p_uf or 0)),
                "unite": "Bars",
                "fill": "",
                "danger": bool(((pres_cond.p_uf or 0) or 0) <= 0.5),
            },
            {
                "type": "",
                "nom": "",
                "valeur": "",
                "unite": "",
                "fill": "",
                "danger": False,
            },
        ],
    }

    filename = generateExcelReport(data, f"Filtration/Filtration - {niveau.date.strftime('%Y-%m-%d')}", f"Filtration-{niveau.date.strftime('%Y-%m-%d')}", force=force_recreate_excel_file)
    print_log("FILTRATION", "page generated")
    
    return (render_to_string(
        template_name="emails/rapport.html",
        context=data
    ) if render_to_HTML_string else data, filename, f"Rapport : Filtration - {niveau.date.strftime('%Y-%m-%d')}")