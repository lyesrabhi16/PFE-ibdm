import logging
from typing import cast
from apscheduler.schedulers.twisted import TwistedScheduler
from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.conf import settings

from emails.models import EmailSchedule, sentEmail
from siroperie.consumers import SucreConsumer
from siroperie.serializers import SucreSerializer
from siroperie.models import Sucre
from channels_redis.core import RedisChannelLayer
from django.core.mail import send_mail
from datetime import datetime
from datetime import timedelta
from users.models import User

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

def sendTestEmail():
    print("sending test email")
    send_mail(
        fail_silently=False,
        subject="IBDM - Test Email",
        message="This is a test email from IBDM",
        from_email=settings.EMAIL_HOST_USER,
        recipient_list=[
            "lyes.rabhi.020@gmail.com",
        ]
    )
    print("test email sent")



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
            message= f"test: ${email.rapport} ${email.temps_envoi} ${email.interval}",
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
