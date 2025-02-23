import logging
from typing import cast
from urllib.request import Request
from apscheduler.schedulers.twisted import TwistedScheduler
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.conf import settings

from emails.models import EmailSchedule, sentEmail
from siroperie.views import getSucreAtSpecificTime
from siroperie.consumers import SucreConsumer
from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre
from channels_redis.core import RedisChannelLayer
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
    second="*/10",
    id="broadcast_sucre",
)
scheduler.pause_job("broadcast_sucre")
def Manager():

    sucre_broadcast_job =  scheduler.get_job("broadcast_sucre")
    if(SucreConsumer.connected_count == 0 and sucre_broadcast_job.next_run_time is not None):
        logging.log(logging.INFO, "manager stopping broadcast_sucre")

        scheduler.pause_job("broadcast_sucre")
    elif (SucreConsumer.connected_count > 0 and sucre_broadcast_job.next_run_time is None):
        logging.log(logging.INFO, "manager starting broadcast_sucre")
        scheduler.resume_job("broadcast_sucre")
        
scheduler.add_job(
    Manager,
    "interval",
    seconds=0.1,
    id="Manager",
    replace_existing=True,
    
)


def getHtmlMessage(email: EmailSchedule):
    now = datetime.now()
    match (email.rapport):
        case ("inventaire-sucre"):
            sucre = Sucre.objects.filter(
                        date__year= now.year,
                        date__month= now.month,
                        date__day= now.day,
                        date__hour= 0,
                        date__minute= 0
                    ).first()
            total_tetra = (sucre.t_s21 or 0) + (sucre.t_s22 or 0) + (sucre.t_s23 or 0) + (sucre.t_s24 or 0) + (sucre.t_s25 or 0)
            total_adue = (sucre.a_t02 or 0) + (sucre.a_t03 or 0) + (sucre.a_t04 or 0) + (sucre.a_t05 or 0) + (sucre.a_t06 or 0)
            return render_to_string(
                template_name="emails/siroperie/inventaire-sucre.html",
                context={
                    "date": sucre.date.strftime("%Y-%m-%d %H:%M:%S"), 
                    "ts21": {
                        "inL": "{:.2f}".format(sucre.ts21),
                        "inKG": "{:.2f}".format(sucre.ts21 * 1.33),
                        "Fill": "{:.2f}".format(sucre.ts21 * 100 / 60000),
                        "color": "red" if (sucre.ts21 or 0) <= 6000  else "green"
                    },
                    "ts22": {
                        "inL": "{:.2f}".format(sucre.ts22),
                        "inKG": "{:.2f}".format(sucre.ts22 * 1.33),
                        "Fill": "{:.2f}".format(sucre.ts22 * 100 / 60000),
                        "color": "red" if (sucre.ts22 or 0) <= 6000  else "green"
                    },
                    "ts23": {
                        "inL": "{:.2f}".format(sucre.ts23),
                        "inKG": "{:.2f}".format(sucre.ts23 * 1.33),
                        "Fill": "{:.2f}".format(sucre.ts23 * 100 / 60000),
                        "color": "red" if (sucre.ts23 or 0) <= 6000  else "green"
                    },
                    "ts24": {
                        "inL": "{:.2f}".format(sucre.ts24),
                        "inKG": "{:.2f}".format(sucre.ts24 * 1.33),
                        "Fill": "{:.2f}".format(sucre.ts24 * 100 / 60000),
                        "color": "red" if (sucre.ts24 or 0) <= 6000  else "green"
                    },
                    "ts25": {
                        "inL": "{:.2f}".format(sucre.ts25),
                        "inKG": "{:.2f}".format(sucre.ts25 * 1.33),
                        "Fill": "{:.2f}".format(sucre.ts25 * 100 / 60000),
                        "color": "red" if (sucre.ts25 or 0) <= 6000  else "green"
                    },
                    "total_tetra": {
                        "inL": "{:.2f}".format(total_tetra),
                        "inKG": "{:.2f}".format(total_tetra * 1.33),
                        "Fill": "{:.2f}".format(total_tetra * 100 / 300000),
                        "color": "red" if total_tetra <= 30000  else "green"
                    },
                    "at02": {
                        "inL": "{:.2f}".format(sucre.at02),
                        "inKG": "{:.2f}".format(sucre.at02 * 1.33),
                        "Fill": "{:.2f}".format(sucre.at02 * 100 / 140000),
                        "color": "red" if (sucre.at02 or 0) <= 14000  else "green"
                    },
                    "at03": {
                        "inL": "{:.2f}".format(sucre.at03),
                        "inKG": "{:.2f}".format(sucre.at03 * 1.33),
                        "Fill": "{:.2f}".format(sucre.at03 * 100 / 140000),
                        "color": "red" if (sucre.at03 or 0) <= 14000  else "green"
                    },
                    "at04": {
                        "inL": "{:.2f}".format(sucre.at04),
                        "inKG": "{:.2f}".format(sucre.at04 * 1.33),
                        "Fill": "{:.2f}".format(sucre.at04 * 100 / 140000),
                        "color": "red" if (sucre.at04 or 0) <= 14000  else "green"
                    },
                    "at05": {
                        "inL": "{:.2f}".format(sucre.at05),
                        "inKG": "{:.2f}".format(sucre.at05 * 1.33),
                        "Fill": "{:.2f}".format(sucre.at05 * 100 / 60000),
                        "color": "red" if (sucre.at05 or 0) <= 6000  else "green"
                    },
                    "at06": {
                        "inL": "{:.2f}".format(sucre.at06),
                        "inKG": "{:.2f}".format(sucre.at06 * 1.33),
                        "Fill": "{:.2f}".format(sucre.at06 * 100 / 60000),
                        "color": "red" if (sucre.at06 or 0) <= 6000  else "green"
                    },
                    "total_adue": {
                        "inL": "{:.2f}".format(total_adue),
                        "inKG": "{:.2f}".format(total_adue * 1.33),
                        "Fill": "{:.2f}".format(total_adue * 100 / 540000),
                        "color": "red" if total_adue <= 54000  else "green"
                    },
                    "total": {
                        "inL": "{:.2f}".format(total_tetra + total_adue),
                        "inKG": "{:.2f}".format((total_tetra + total_adue) * 1.33),
                        "Fill": "{:.2f}".format((total_tetra + total_adue) * 100 / 840000),
                        "color": "red" if (total_tetra + total_adue) <= 84000  else "green"
                    }

                }
            )


def sendEmail(email: EmailSchedule):

    logging.log(logging.WARNING, f"send email: {email}")

    send_to = set()
    users = set()

    for user in email.scheduled_users.all():
        send_to.add(user.email)
        users.add(user)
    
    for role in email.scheduled_roles.all():
        for user in User.objects.filter(role=role):
            send_to.add(user.email)
            users.add(user)
    logging.log(logging.WARNING, f"send email to: {send_to}")

    for email_str in send_to:
        send_mail(
            fail_silently=True,
            subject= "IBDM test email",
            #message= f"test: ${email.rapport} ${email.temps_envoi} ${email.interval}",
            message=getHtmlMessage(email),
            from_email=settings.EMAIL_HOST_USER,
            recipient_list=[email_str]
        )
    for user in users:
        sentEmail.objects.create(receptionist=user, schedule=email)

    if( email.next_run_time is not None ):
        logging.log(logging.INFO, "setting next run time")
        email.next_run_time = email.next_run_time + timedelta(days=email.interval_manual)
        email.save()
    else:
        raise ValueError("next_run_time is None, how did this happen?")
    
        




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
    logging.log(logging.WARNING, f"scheduled emails: {scheduled_emails}")

    for email in scheduled_emails:
        sendEmail(email)


scheduler.add_job(
    email_scheduler,
    "interval",
    seconds=20,
    id="email_scheduler",
)
logging.getLogger('apscheduler.executors.default').setLevel(logging.WARNING)
scheduler.start()
