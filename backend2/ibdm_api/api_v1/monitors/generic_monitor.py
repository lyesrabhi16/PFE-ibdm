from datetime import timedelta, datetime
import threading
from django.core.mail import send_mail
from django.conf import settings
import logging
from emails.models import AlertEmail, sentEmail
from users.models import User
from django.template.loader import render_to_string


def GenericMonitor(monitored_value_tag: str, monitored_object_value: object, name: str, lock: threading.Lock):
    with lock:
        logging.info(f"{name}: checking...")
        alerts = AlertEmail.objects.filter(monitored_value__startswith=monitored_value_tag, enabled=True)
        for alert in alerts:
            monitored_value = alert.monitored_value.split(".")[1]
            value = getattr(monitored_object_value, monitored_value) or 0
            if value <= alert.danger_point:
                recipients = set().union(
                    alert.send_to_users.all(),
                    User.objects.filter(role__in=alert.send_to_roles.all())
                )

                for user in recipients:
                    if sentEmail.objects.filter(alert=alert, receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.danger_reminder_interval)).count() == 0:
                        logging.info(f"{name} : {alert.monitored_value} Sending danger alert email to '{user.email}'")
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
                        sentEmail.objects.create(alert=alert, receptionist=user)
                        logging.info(f"{name} : {alert.monitored_value} sent danger alert email to '{user.email}'")
            elif value <= alert.warning_point:
                recipients = set().union(
                    alert.send_to_users.all(),
                    User.objects.filter(role__in=alert.send_to_roles.all())
                )
                for user in recipients:
                    if sentEmail.objects.filter(alert=alert, receptionist=user, temps_envoi__gte=datetime.now() - timedelta(days=alert.warning_reminder_interval)).count() == 0:
                        logging.info(f"{name} : {alert.monitored_value} Sending warning alert email to '{user.email}'")
                        send_mail(
                            subject= f"IBDM Alert Warning: {alert.monitored_value}",
                            message="",
                            html_message= render_to_string(
                                template_name="emails/alert.html",
                                context={
                                    'alert': alert.monitored_value,
                                    'type': 'Warning',
                                    'valeur_actual': value,
                                    'message': alert.custom_alert_message
                                }
                            ),
                            from_email=settings.EMAIL_OF_SENDER,
                            recipient_list=[user.email]
                        )
                        sentEmail.objects.create(alert=alert, receptionist=user)
                        logging.info(f"{name} : {alert.monitored_value} sent warning alert email to '{user.email}'")
            logging.info(f"{name}: done.")
            

