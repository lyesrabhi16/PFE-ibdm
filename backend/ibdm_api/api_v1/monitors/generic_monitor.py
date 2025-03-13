from datetime import timedelta, datetime
import threading
from django.core.mail import send_mail
from django.conf import settings
import logging
from emails.models import CUSTOM_MONITORED_VALUES, AlertEmail, SentAlertEmail, sentEmail
from users.models import User
from django.template.loader import render_to_string



def getValueForCustomExpression(action:str, attrs: list, obj: object):
    if action == "total":
        return sum((getattr(obj, attr) or 0)  for attr in attrs)
    raise ValueError(f"Unknown Custom Expression action '{action}'")
    

def GenericMonitor(monitored_value_tag: str, monitored_object_value: object, name: str, lock: threading.Lock):
    with lock:
        logging.info(f"{name}: checking...")
        alerts = AlertEmail.objects.filter(monitored_value__startswith=monitored_value_tag, enabled=True)
        for alert in alerts:
            monitored_value_expression = alert.monitored_value.split(".")
            monitored_value = monitored_value_expression[-1]
            value : int = 0
            if alert.monitored_value in CUSTOM_MONITORED_VALUES:
                action = monitored_value_expression[1]
                attrs : set = CUSTOM_MONITORED_VALUES[alert.monitored_value]
                value = getValueForCustomExpression(action, list(attrs), monitored_object_value)
            else:
                value = getattr(monitored_object_value, monitored_value) or 0

            print(f"{name} : {alert.monitored_value} value: {value} danger_point: {alert.danger_point} warning_point: {alert.warning_point}")
            if value <= alert.danger_point:
                recipients = set().union(
                    alert.send_to_users.all(),
                    User.objects.filter(role__in=alert.send_to_roles.all())
                )

                for user in recipients:
                    if sentEmail.objects.filter(alert__alert=alert, receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.danger_reminder_interval)).count() == 0:
                        logging.info(f"{name} : {alert.monitored_value} Sending danger alert email to '{user.email}'")
                        sendDangerAlertEmail(alert, value, user, name)
            elif value <= alert.warning_point:
                recipients = set().union(
                    alert.send_to_users.all(),
                    User.objects.filter(role__in=alert.send_to_roles.all())
                )
                for user in recipients:
                    if sentEmail.objects.filter(alert__alert=alert, receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.warning_reminder_interval)).count() == 0:
                        sendWarningAlertEmail(name, alert, user, value)
            alert.save()
            logging.info(f"{name}: done.")


def sendWarningAlertEmail(name, alert, user, value):
    logging.info(f"{name} : {alert.monitored_value} Sending warning alert email to '{user.email}'")
    send_mail(
        subject= f"IBDM Alert D'Avertissement: {alert.monitored_value}",
        message="",
        html_message= render_to_string(
            template_name="emails/alert.html",
            context={
                'alert': alert.monitored_value,
                'type': 'Avertissement',
                'valeur_actual': value,
                'message': alert.custom_alert_message
            }
        ),
        from_email=settings.EMAIL_OF_SENDER,
        recipient_list=[user.email]
    )
    sent_alert = SentAlertEmail.objects.create(alert=alert, at_value=value, alert_type="danger")
    sentEmail.objects.create(alert=sent_alert, receptionist=user)
    logging.info(f"{name} : {alert.monitored_value} sent warning alert email to '{user.email}'")


def sendDangerAlertEmail(alert, value, user, name):
    send_mail(
        subject= f"IBDM Alert Danger: {alert.monitored_value}",
        message="",
        html_message= render_to_string(
            template_name="emails/alert.html",
            context={
                'alert': alert.monitored_value,
                'type': 'Danger',
                'valeur_actual': value,
                'message': alert.custom_alert_message
            }
        ),
        from_email=settings.EMAIL_OF_SENDER,
        recipient_list=[user.email]
    )
    sent_alert = SentAlertEmail.objects.create(alert=alert, at_value=value, alert_type="warning")
    sentEmail.objects.create(alert=sent_alert, receptionist=user)
    logging.info(f"{name} : {alert.monitored_value} sent danger alert email to '{user.email}'")
            

