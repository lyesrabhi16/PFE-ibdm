from datetime import timedelta, datetime
import threading
from django.core.mail import send_mail
from django.conf import settings
from emails.models import CUSTOM_MONITORED_VALUES, AlertEmail, SentAlertEmail, sentEmail
from users.models import User
from django.template.loader import render_to_string
from logs.logging import logger as logging
from tenacity import retry, stop_after_delay, wait_chain, wait_fixed


def getValueForCustomExpression(action:str, attrs: list, obj: object) -> float:
    if action == "total":
        return sum((getattr(obj, attr) or 0)  for attr in attrs)
    raise ValueError(f"Unknown Custom Expression action '{action}'")
    

def checkValue(value, monitor_point, type="DESC") -> bool:
    match type:
        case "ASC":
            return value >= monitor_point
        case "DESC":
            return value <= monitor_point
        case _:
            raise ValueError(f"genericMonitor# unknown type ({type}) in checkValue")

def GenericMonitor(monitored_value_tag: str, monitored_object_value: object, name: str, lock: threading.Lock):
    with lock:
        logging.info(f"{name}# checking...")
        alerts = AlertEmail.objects.filter(monitored_value__startswith=monitored_value_tag, enabled=True)
        logging.info(f'{name}# found active alerts {alerts}')
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

            logging.info(f"{name}# {alert.monitored_value} value: {value} danger_point: {alert.danger_point} warning_point: {alert.warning_point} type: {alert.monitor_type}")
            if checkValue(value, alert.danger_point, alert.monitor_type):
                recipients = set().union(
                    alert.send_to_users.all(),
                    User.objects.filter(role__in=alert.send_to_roles.all())
                )
                for user in recipients:
                    sent_alerts = sentEmail.objects.filter(alert__alert=alert, alert__alert_type="danger", receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.danger_reminder_interval))
                    logging.info(f"{name}# {alert.monitored_value} found sent danger alerts to '{user.email}' : {sent_alerts}")
                    if sent_alerts.count() == 0:
                        sendDangerAlertEmail(alert, value, user, name)
            elif checkValue(value, alert.warning_point, alert.monitor_type):
                recipients = set().union(
                    alert.send_to_users.all(),
                    User.objects.filter(role__in=alert.send_to_roles.all())
                )
                for user in recipients:
                    sent_alerts = sentEmail.objects.filter(alert__alert=alert, alert__alert_type="warning",receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.warning_reminder_interval))
                    logging.info(f"{name}# {alert.monitored_value} found sent warning alerts to '{user.email}' : {sent_alerts}")
                    if sent_alerts.count() == 0:
                        sendWarningAlertEmail(name, alert, user, value)
            alert.save()
            logging.info(f"{name}# done.")


def before_retry_log(*args):
    logging.info(f"genericMonitor# retry-before: {args}")


def after_retry_log(*args):
    logging.info(f"genericMonitor# retry-after: {args}")


@retry(
    wait=wait_fixed(30), 
    stop=stop_after_delay(60*60),
    before=before_retry_log,
    after=after_retry_log,
)
def sendWarningAlertEmail(name, alert, user, value):
    logging.info(f"{name}# {alert.monitored_value} Sending warning alert email to '{user.email}'")
    try:
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
    except Exception as e:
        logging.info("genericMonitor# error sending email, trying with secondary provider, error is: {e}")
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
            from_email=settings.EMAIL_OF_SENDER2,
            connection=settings.EMAIL_SECONDARY_PROVIDER,
            recipient_list=[user.email]
        )
    sent_alert = SentAlertEmail.objects.create(alert=alert, at_value=value, alert_type="warning")
    sentEmail.objects.create(temps_envoi=datetime.now(), alert=sent_alert, receptionist=user)
    logging.info(f"{name}# {alert.monitored_value} sent warning alert email to '{user.email}' at {datetime.now()}")

@retry(
    wait=wait_fixed(30), 
    stop=stop_after_delay(60*60),
    before=before_retry_log,
    after=after_retry_log,
)
def sendDangerAlertEmail(alert, value, user, name):
    logging.info(f"{name}# {alert.monitored_value} Sending danger alert email to '{user.email}'")
    try:
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
    except Exception as e:
        logging.info("genericMonitor# error sending email, trying with secondary provider, error is: {e}")
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
            from_email=settings.EMAIL_OF_SENDER2,
            connection=settings.EMAIL_SECONDARY_PROVIDER,
            recipient_list=[user.email]
        )
    sent_alert = SentAlertEmail.objects.create(alert=alert, at_value=value, alert_type="danger")
    sentEmail.objects.create(temps_envoi=datetime.now(), alert=sent_alert, receptionist=user)
    logging.info(f"{name}# {alert.monitored_value} sent danger alert email to '{user.email}' at {datetime.now()}")
            

