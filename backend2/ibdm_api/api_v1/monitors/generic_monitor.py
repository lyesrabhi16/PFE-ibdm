from datetime import timedelta, datetime
from typing import Optional
import threading
from venv import logger
from django.core.mail import send_mail
from django.conf import settings
import logging
from emails.models import AlertEmail, sentEmail
from users.models import User


def GenericMonitor(monitored_value_tag: str, monitored_object_value: object, name: str, lock: threading.Lock):
    with lock:
        logging.info(f"{name}: checking...")
        alerts = AlertEmail.objects.filter(monitored_value__startswith=monitored_value_tag)
        for alert in alerts:
            if not alert.enabled:
                continue
            monitered_value = alert.monitored_value.split(".")[1]
            value = getattr(monitored_object_value, monitered_value) or 0
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
                        logging.info(f"{name} : {alert.monitored_value} sent danger alert email to '{user.email}'")
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
                        logging.info(f"{name} : {alert.monitored_value} sent warning alert email to '{user.email}'")
            logging.info(f"{name}: done.")
            

