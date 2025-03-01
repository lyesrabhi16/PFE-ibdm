from django.core.mail import EmailMessage
import logging
import threading
from apscheduler.schedulers.twisted import TwistedScheduler
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.conf import settings
import math
from emails.models import AlertEmail, EmailSchedule, sentEmail
from filtration.consumers import FiltrationConsumer
from filtration.models import Debit, Niveau, PresCond, Volume
from filtration.serializers import DebitSerializer, NiveauSerializer, PresCondSerializer, VolumeSerializer
from api_v1.excel_helpers import generateExcelReport
from siroperie.consumers import SucreConsumer
from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre
from django.core.mail import send_mail
from datetime import datetime
from datetime import timedelta
from users.models import User
from django.template.loader import render_to_string

scheduler = TwistedScheduler()


def get_sucre_latest_data():
    return Sucre.objects.latest("date")

def broadcast_sucre():
    channel_layer = get_channel_layer()

    data = get_sucre_latest_data()
    print("data:", data)
    
    sucreMonitor(data)
    
    async_to_sync(channel_layer.group_send)(
        "sucre",
        {
            "type": "sucre.data",
            "data": SucreSerializer(data, context={ "request": None }).data,
        },
    )
scheduler.add_job(
    broadcast_sucre,
    "cron",
    #minute="*/1", works
    second="*/1",
    id="broadcast_sucre",
)
#scheduler.pause_job("broadcast_sucre")

def sucreMonitor(sucre: Sucre):
    logging.info("sucreMonitor: checking...")
    alerts = AlertEmail.objects.filter(monitored_value__startswith="sucre")
    for alert in alerts:
        if not alert.enabled:
            continue
        monitered_value = alert.monitored_value.split(".")[1]
        value = getattr(sucre, monitered_value) or 0
        if value <= alert.danger_point:
            recipients = set().union(
                alert.send_to_users.all(),
                User.objects.filter(role__in=alert.send_to_roles.all())
            )

            for user in recipients:

                if sentEmail.objects.filter(alert=alert, receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.danger_reminder_interval)).count() == 0:
                    send_mail(
                        subject= f"IBDM Alert Danger: {alert.monitored_value}",
                        message= alert.custom_alert_message or f"Alert: {alert.monitored_value} has reached a dangerous point of {value}",
                        from_email=settings.EMAIL_HOST_USER,
                        recipient_list=[user.email]
                    )
                    sentEmail.objects.create(alert=alert, receptionist=user)
                    logging.info(f"sucreMonitor : {alert.monitored_value} sent danger alert email to '{user.email}'")
        elif value >= alert.warning_point:
            recipients = set().union(
                alert.send_to_users.all(),
                User.objects.filter(role__in=alert.send_to_roles.all())
            )
            for user in recipients:
                if sentEmail.objects.filter(alert=alert, receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.warning_reminder_interval)).count() == 0:
                    send_mail(
                        subject= f"IBDM Alert Warning: {alert.monitored_value}",
                        message= alert.custom_alert_message or f"Alert: {alert.monitored_value} has reached a warning point of {value}",
                        from_email=settings.EMAIL_HOST_USER,
                        recipient_list=[user.email]
                    )
                    sentEmail.objects.create(alert=alert, receptionist=user)
                    logging.info(f"sucreMonitor : {alert.monitored_value} sent warning alert email to '{user.email}'")


def broadcast_filtration():
    
    channel_layer = get_channel_layer()


    niveau_latest = Niveau.objects.latest("date")
    #logging.info(f"latest niveau: {str(niveau_latest)}")
    
    debit_latest = Debit.objects.latest("date")
    #logging.info(f"latest debit_latest: {str(debit_latest)}")

    volume_latest = Volume.objects.latest("date")
    #logging.info(f"latest volume_latest: {str(volume_latest)}")

    pres_cond_latest = PresCond.objects.latest("date")
    #logging.info(f"latest pres_cond_latest: {str(pres_cond_latest)}")

    logging.info("broadcast_filtration done retrieving data and now broadcasting")

    data = {
                "niveau": NiveauSerializer(niveau_latest).data,
                "debit": DebitSerializer(debit_latest).data,
                "pres_cond": PresCondSerializer(pres_cond_latest).data,
                "volume": VolumeSerializer(volume_latest).data,
            }

    async_to_sync(channel_layer.group_send)(
        "filtration",
        {
            "type": "filtration.data",
            "data": data,
        },
    )
scheduler.add_job(
    broadcast_filtration,
    "cron",
    #minute="*/1", works
    second="*/1",
    id="broadcast_filtration",
)
#scheduler.pause_job("broadcast_filtration")



def Manager():

    sucre_broadcast_job =  scheduler.get_job("broadcast_sucre")
    if(SucreConsumer.connected_count == 0 and sucre_broadcast_job.next_run_time is not None):
        logging.log(logging.INFO, "manager stopping broadcast_sucre")

        scheduler.pause_job("broadcast_sucre")
    elif (SucreConsumer.connected_count > 0 and sucre_broadcast_job.next_run_time is None):
        logging.log(logging.INFO, "manager starting broadcast_sucre")
        scheduler.resume_job("broadcast_sucre")

    filtration_broadcast_job =  scheduler.get_job("broadcast_filtration")
    if(FiltrationConsumer.connected_count == 0 and filtration_broadcast_job.next_run_time is not None):
        logging.log(logging.INFO, "manager stopping broadcast_filtration")

        scheduler.pause_job("broadcast_filtration")
    elif (FiltrationConsumer.connected_count > 0 and filtration_broadcast_job.next_run_time is None):
        logging.log(logging.INFO, "manager starting broadcast_filtration")
        scheduler.resume_job("broadcast_filtration")
        
""" scheduler.add_job(
    Manager,
    "interval",
    seconds=0.1,
    id="Manager",
    replace_existing=True,
    
)
 """

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
                    "synthese": f"il faut commander {a_commander} { 'Citernes' if a_commander > 1 else 'Citerne'}" if a_commander > 0 else "Pas de commande nécessaire",
                    "header_codes": ["cuve", "inL", "inKG", "Fill"],
                    "suffixes": {
                        "cuve": "",
                        "inL": "L",
                        "inKG": "KG",
                        "Fill": "%",
                    },
                    "headers":[{"title":"Cuve", "code": "cuve"},{"title": "Niveau L", "code": "inL", "suffix": "L"}, {"title":"Niveau KG", "code":"inKG", "suffix": "KG"}, {"title":"Fill", "code": "Fill", "suffix": "%"}],
                    "rows":[ 
                    {
                        "cuve": "ts21",
                        "inL": "{:.2f}".format((sucre.t_s21 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s21 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s21 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s21 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "ts22",
                        "inL": "{:.2f}".format((sucre.t_s22 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s22 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s22 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s22 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "ts23",
                        "inL": "{:.2f}".format((sucre.t_s23 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s23 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s23 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s23 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "ts24",
                        "inL": "{:.2f}".format((sucre.t_s24 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s24 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s24 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s24 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "ts25",
                        "inL": "{:.2f}".format((sucre.t_s25 or 0)),
                        "inKG": "{:.2f}".format((sucre.t_s25 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.t_s25 or 0) * 100 / 60000),
                        "danger": True if ((sucre.t_s25 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "TOTAL TETRA",
                        "inL": "{:.2f}".format(total_tetra),
                        "inKG": "{:.2f}".format(total_tetra * 1.33),
                        "Fill": "{:.2f}".format(total_tetra * 100 / 300000),
                        "danger": True if total_tetra <= 30000  else False,
                        "highlight": True,
                    },
                    {
                        "cuve": "at02",
                        "inL": "{:.2f}".format((sucre.a_t02 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t02 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t02 or 0) * 100 / 140000),
                        "danger": True if ((sucre.a_t02 or 0) or 0) <= 14000  else False
                    },
                    {
                        "cuve": "at03",
                        "inL": "{:.2f}".format((sucre.a_t03 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t03 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t03 or 0) * 100 / 140000),
                        "danger": True if ((sucre.a_t03 or 0) or 0) <= 14000  else False
                    },
                    {
                        "cuve": "at04",
                        "inL": "{:.2f}".format((sucre.a_t04 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t04 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t04 or 0) * 100 / 140000),
                        "danger": True if ((sucre.a_t04 or 0) or 0) <= 14000  else False
                    },
                    {
                        "cuve": "at05",
                        "inL": "{:.2f}".format((sucre.a_t05 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t05 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t05 or 0) * 100 / 60000),
                        "danger": True if ((sucre.a_t05 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "at06",
                        "inL": "{:.2f}".format((sucre.a_t06 or 0)),
                        "inKG": "{:.2f}".format((sucre.a_t06 or 0) * 1.33),
                        "Fill": "{:.2f}".format((sucre.a_t06 or 0) * 100 / 60000),
                        "danger": True if ((sucre.a_t06 or 0) or 0) <= 6000  else False
                    },
                    {
                        "cuve": "TOTAL ADUE",
                        "inL": "{:.2f}".format(total_adue),
                        "inKG": "{:.2f}".format(total_adue * 1.33),
                        "Fill": "{:.2f}".format(total_adue * 100 / 540000),
                        "danger": True if total_adue <= 54000  else False,
                        "highlight": True,
                    },
                    {
                        "cuve": "TOTAL",
                        "inL": "{:.2f}".format(total_tetra + total_adue),
                        "inKG": "{:.2f}".format((total_tetra + total_adue) * 1.33),
                        "Fill": "{:.2f}".format((total_tetra + total_adue) * 100 / 840000),
                        "highlight": True,
                        "danger": True if (total_tetra + total_adue) <= 84000  else False
                    },],

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
            "from_email":settings.EMAIL_HOST_USER,
            "to":[email_str]
        }).start()
    for user in users:
        sentEmail.objects.create(receptionist=user, schedule=email)

    if( email.next_run_time is not None ):
        logging.log(logging.INFO, "emailScheduler: setting next run time")
        email.next_run_time = email.next_run_time + timedelta(days=email.interval_manual)
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

        email.next_run_time = next_r_t if next_r_t > datetime.now() else next_r_t + timedelta(days= email.interval_manual)
        email.save()

    scheduled_emails = EmailSchedule.objects.filter(
        next_run_time__year=now.year,
        next_run_time__month=now.month,
        next_run_time__day=now.day,
        next_run_time__hour=now.hour,
        next_run_time__minute=now.minute,        
        )
    #logging.log(logging.WARNING, f"scheduled emails: {scheduled_emails}")
    emails_to_be_sent = {
        email for email in scheduled_emails if email not in emails_in_process
    }
    for email in emails_to_be_sent:
       threading.Thread(target=sendEmail, args=(email,)).start()


scheduler.add_job(
    email_scheduler,
    "interval",
    seconds=20,
    id="email_scheduler",
)

logging.getLogger('apscheduler.executors.default').setLevel(logging.WARNING)
scheduler.start()
