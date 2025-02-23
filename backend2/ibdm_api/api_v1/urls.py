import math
from venv import logger
from django.urls import include, path


def test(request):
    from siroperie.models import Sucre
    from django.shortcuts import render
    from datetime import datetime

    now = datetime.now()
    sucre = Sucre.objects.filter(
                        date__year= now.year,
                        date__month= now.month,
                        date__day= now.day,
                        date__hour= 0,
                        date__minute= 0
                    ).first()
    total_tetra = (sucre.t_s21 or 0) + (sucre.t_s22 or 0) + (sucre.t_s23 or 0) + (sucre.t_s24 or 0) + (sucre.t_s25 or 0)
    total_adue = (sucre.a_t02 or 0) + (sucre.a_t03 or 0) + (sucre.a_t04 or 0) + (sucre.a_t05 or 0) + (sucre.a_t06 or 0)
    a_commander = math.floor((840000 - (total_tetra + total_adue)) / 20000)
    logger.info(f"total_tetra: {total_tetra} total_adue: {total_adue} a_commander: {a_commander}")
    return render(
        request,
        template_name="emails/siroperie/inventaire-sucre.html",
        context={
                    "date": sucre.date.strftime("%Y-%m-%d"), 
                    "ts21": {
                        "inL": "{:.2f}".format((sucre.t_s21 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s21 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s21 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s21 or 0) or 0) <= 6000  else False
                    },
                    "ts22": {
                        "inL": "{:.2f}".format((sucre.t_s22 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s22 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s22 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s22 or 0) or 0) <= 6000  else False
                    },
                    "ts23": {
                        "inL": "{:.2f}".format((sucre.t_s23 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s23 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s23 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s23 or 0) or 0) <= 6000  else False
                    },
                    "ts24": {
                        "inL": "{:.2f}".format((sucre.t_s24 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s24 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s24 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s24 or 0) or 0) <= 6000  else False
                    },
                    "ts25": {
                        "inL": "{:.2f}".format((sucre.t_s25 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s25 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s25 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s25 or 0) or 0) <= 6000  else False
                    },
                    "total_tetra": {
                        "inL": "{:.2f}".format(total_tetra),
                        "inKG": "{:.2f}".format(total_tetra * 1.33),
                        "Fill": "{:.2f}".format(total_tetra * 100 / 300000),
                        "danger": True if total_tetra <= 30000  else False
                    },
                    "at02": {
                        "inL": "{:.2f}".format((sucre.a_t02 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t02 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t02 or 0) * 100 / 140000),
                        "danger": True if ((sucre.a_t02 or 0) or 0) <= 14000  else False
                    },
                    "at03": {
                        "inL": "{:.2f}".format((sucre.a_t03 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t03 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t03 or 0) * 100 / 140000),
                        "danger": True if ((sucre.a_t03 or 0) or 0) <= 14000  else False
                    },
                    "at04": {
                        "inL": "{:.2f}".format((sucre.a_t04 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t04 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t04 or 0) * 100 / 140000),
                        "danger": True if ((sucre.a_t04 or 0) or 0) <= 14000  else False
                    },
                    "at05": {
                        "inL": "{:.2f}".format((sucre.a_t05 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t05 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t05 or 0) * 100 / 60000),
                        "danger": True if ((sucre.a_t05 or 0) or 0) <= 6000  else False
                    },
                    "at06": {
                        "inL": "{:.2f}".format((sucre.a_t06 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t06 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t06 or 0) * 100 / 60000),
                        "danger": True if ((sucre.a_t06 or 0) or 0) <= 6000  else False
                    },
                    "total_adue": {
                        "inL": "{:.2f}".format(total_adue),
                        "inKG": "{:.2f}".format(total_adue * 1.33),
                        "Fill": "{:.2f}".format(total_adue * 100 / 540000),
                        "danger": True if total_adue <= 54000  else False
                    },
                    "total": {
                        "inL": "{:.2f}".format(total_tetra + total_adue),
                        "inKG": "{:.2f}".format((total_tetra + total_adue) * 1.33),
                        "Fill": "{:.2f}".format((total_tetra + total_adue) * 100 / 840000),
                        "danger": True if (total_tetra + total_adue) <= 84000  else False
                    },
                    "a_commander": f"il faut commander {a_commander} { 'Citernes' if a_commander > 1 else 'Citerne'}" if a_commander > 0 else "Pas de commande nécessaire"

                }
    )

urlpatterns = [
    path('auth/', include("app_auth.urls"), name='app_auth'),
    path('documentation/', include('documentation.urls'), name='documentation'),
    path('docs/', include('documentation.urls'), name='documentation'),
    path('user-management/', include('users.urls'), name='users'),
    path("siroperie/", include("siroperie.urls"), name="siroperie"),
    path("emails/", include("emails.urls"), name="emails"),
    path("test/", test)
]
