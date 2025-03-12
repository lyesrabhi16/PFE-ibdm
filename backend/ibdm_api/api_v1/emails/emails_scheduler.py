
from datetime import datetime, timedelta
from django.core.mail import EmailMessage
from django.template.loader import render_to_string
from django.conf import settings
import logging
import threading
import math
from api_v1.excel_helpers import generateExcelReport
from emails.models import EmailSchedule, sentEmail
from siroperie.models import Sucre
from users.models import User


def getHtmlMessage(email: EmailSchedule):
    now = datetime.now()
    match (email.rapport):
        case ("inventaire-sucre"):
            now = datetime.now()
    sucre = Sucre.objects.filter(
                        date__year= now.year,
                        date__month= now.month,
                        date__day= now.day,
                        date__hour= 0,
                        date__minute= 0
                    ).first()

    if (sucre is None):
        return "les données de sucre ne sont pas disponible pour le "+now.strftime("%Y-%m-%d")

    total_tetra = (sucre.t_s21 or 0) + (sucre.t_s22 or 0) + (sucre.t_s23 or 0) + (sucre.t_s24 or 0) + (sucre.t_s25 or 0)
    total_adue = (sucre.a_t02 or 0) + (sucre.a_t03 or 0) + (sucre.a_t04 or 0) + (sucre.a_t05 or 0) + (sucre.a_t06 or 0)
    a_commander = math.floor((840000 - (total_tetra + total_adue)) / 20000)
    interval = email.interval if email.interval != "manual" else f"{email.interval_manual} jours"
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

    filename = generateExcelReport(data, f"Inventaire Du Sucre - {sucre.date.strftime('%Y-%m-%d')}", f"Inventaire-Du-Sucre-{sucre.date.strftime('%Y-%m-%d')}")
    return (render_to_string(
        template_name="emails/rapport.html",
        context=data
    ), filename, f"Rapport : Inventaire Du Sucre - {sucre.date.strftime('%Y-%m-%d')}")

def sendEmailWithFile(file, **kwargs):
    email_message = EmailMessage(**kwargs)
    email_message.content_subtype = "html"
    if file is not None:
        email_message.attach_file(file)
    email_message.send()
    logging.info(f"emailScheduler: email sent to '{email_message.to}'")

def sendEmail(email: EmailSchedule):
    logging.log(logging.WARNING, f"emailScheduler: send email: {email}")
    emails_in_process.add(email)
    send_to = set()
    users = set()

    for user in email.scheduled_users.all():
        send_to.add(user.email)
        users.add(user)
    
    for role in email.scheduled_roles.all():
        for user in User.objects.filter(role=role):
            send_to.add(user.email)
            users.add(user)
    logging.log(logging.WARNING, f"emailScheduler: send email to: {send_to}")
    message, file, subject = getHtmlMessage(email)
    for email_str in send_to:
        threading.Thread(
            target=sendEmailWithFile,kwargs={
            "file": file,
            "subject":f"IBDM {subject}",
            "body": message,
            "from_email":settings.EMAIL_OF_SENDER,
            "to":[email_str]
        }).start()
    for user in users:
        sentEmail.objects.create(receptionist=user, schedule=email)

    if( email.next_run_time is not None ):
        logging.log(logging.INFO, "emailScheduler: setting next run time")
        email.next_run_time = email.next_run_time + timedelta(days=email.interval_manual or 1)
        email.save()
    else:
        raise ValueError("next_run_time is None, how did this happen?")
    emails_in_process.remove(email)
    
        

emails_in_process = set()
def email_scheduler():
    logging.log(logging.WARNING, "email_scheduler")
    now = datetime.now()

    unscheduled_emails = EmailSchedule.objects.filter(next_run_time=None)
    logging.log(logging.WARNING, f"emails to schedule: {unscheduled_emails}")
    for email in unscheduled_emails:
        next_r_t = datetime(
                year=now.year,
                month=now.month,
                day=now.day,
                hour=email.temps_envoi.hour,
                minute=email.temps_envoi.minute,
                second=email.temps_envoi.second
        )
        if email.interval == "jour":
            email.interval_manual = 1
        elif email.interval == "mois":
            email.interval_manual = 30
        elif email.interval == "semaine":
            email.interval_manual = 7
        if email.interval == "manual" and email.interval_manual is None:
            raise ValueError("interval_manual is None, how did this happen?")

        email.next_run_time = next_r_t if next_r_t > datetime.now() else next_r_t + timedelta(days= email.interval_manual or 1)
        email.save()

    scheduled_emails = EmailSchedule.objects.filter(
        next_run_time__year=now.year,
        next_run_time__month=now.month,
        next_run_time__day=now.day,
        next_run_time__hour=now.hour,
        next_run_time__minute=now.minute,
        )
    logging.log(logging.WARNING, f"scheduled emails: {scheduled_emails}")
    emails_to_be_sent = {
        email for email in scheduled_emails if email not in emails_in_process
    }

    logging.log(logging.WARNING, f'emails to send: {emails_to_be_sent}')
    for email in emails_to_be_sent:
       threading.Thread(target=sendEmail, args=(email,)).start()

