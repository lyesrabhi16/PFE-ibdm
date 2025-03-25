
from datetime import datetime, timedelta
from django.core.mail import EmailMessage
from django.conf import settings
from logs.logging import logger as logging
import threading
from emails.models import EmailSchedule, sentEmail
from api_v1.emails.rapports.inventaire_sucre import rapport_inventaire_sucre
from api_v1.emails.rapports.utilite import rapport_utilite
from api_v1.emails.rapports.filtration import rapport_filtration
from users.models import User

def getHtmlMessage(email: EmailSchedule):
    match (email.rapport):
        case "inventaire-sucre":
            return rapport_inventaire_sucre(email)
        case "utilite":
            return rapport_utilite(email)
        case "filtration":
            return rapport_filtration(email)
        case _:
            raise ValueError(f"emailScheduler# rapport {email.rapport} not found")
            
def sendEmailWithFile(file, **kwargs):
    email_message = EmailMessage(**kwargs)
    email_message.content_subtype = "html"
    if file is not None:
        email_message.attach_file(file)
    email_message.send()
    logging.info(f"emailScheduler#: email sent to '{email_message.to}'")

def sendEmail(email: EmailSchedule, schedule_next=True):
    logging.info(f"emailScheduler# send email: {email}")
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
    logging.info(f"emailScheduler# send email to: {send_to}")
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

    if email.next_run_time is None:
        raise ValueError("emailScheduler# next_run_time is None, how did this happen?")
    if schedule_next:
        logging.info("emailScheduler# setting next run time")
        email.next_run_time = email.next_run_time + timedelta(days=email.interval_manual or 1)
        email.save()
    emails_in_process.remove(email)

emails_in_process = set()
def email_scheduler():
    logging.info(f"emailScheduler# EMAILS IN SENDING PROCESS: {emails_in_process}")
    schedule_unscheduled_emails()
    send_scheduled_emails()
    reschedule_emails()

def send_scheduled_emails():
    now = datetime.now()
    scheduled_emails = EmailSchedule.objects.filter(
        next_run_time__year=now.year,
        next_run_time__month=now.month,
        next_run_time__day=now.day,
        next_run_time__hour=now.hour,
        next_run_time__minute=now.minute,
        )
    logging.info(f"emailScheduler# scheduled emails: {scheduled_emails}")
    emails_to_be_sent = {
        email for email in scheduled_emails if email not in emails_in_process
    }

    logging.info(f'emailScheduler# emails to send: {emails_to_be_sent}')
    for email in emails_to_be_sent:
       threading.Thread(target=sendEmail, args=(email,)).start()

def reschedule_emails():
    now = datetime.now()
    reschedule_emails  = EmailSchedule.objects.filter(next_run_time__lt=now)
    logging.info(f"emailScheduler# emails to reschedule: {reschedule_emails}")
    for email in reschedule_emails:
        if email.next_run_time is None:
            raise ValueError("emailScheduler# next_run_time is None, how did this happen?")
        days_to_add = max(
            (now - email.next_run_time.replace(tzinfo=None)).days, (email.interval_manual or 1)
        )
        email.next_run_time = email.next_run_time + timedelta(days=days_to_add)
        email.save()

def schedule_unscheduled_emails():
    now = datetime.now()
    unscheduled_emails = EmailSchedule.objects.filter(next_run_time=None)
    logging.info(f"emailScheduler# emails to schedule: {unscheduled_emails}")
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
            raise ValueError("emailScheduler# interval_manual is None, how did this happen?")

        email.next_run_time = next_r_t if next_r_t > datetime.now() else next_r_t + timedelta(days= email.interval_manual or 1)
        email.save()
    
