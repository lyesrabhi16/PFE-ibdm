import logging
from apscheduler.schedulers.twisted import TwistedScheduler
from api_v1.broadcasts.filtration_broadcast import broadcast_filtration
from api_v1.broadcasts.sucre_broadcast import broadcast_sucre
from api_v1.broadcasts.sent_emails_broadcast import broadcast_sent_emails
from api_v1.broadcasts.utilite_broadcast import broadcast_utilite
from api_v1.emails.emails_scheduler import email_scheduler

scheduler = TwistedScheduler()


scheduler.add_job(
    broadcast_sucre,
    "cron",
    #minute="*/1", works
    second="*/1",
    id="broadcast_sucre",
)
#scheduler.pause_job("broadcast_sucre")


scheduler.add_job(
    broadcast_filtration,
    "cron",
    #minute="*/1", works
    second="*/1",
    id="broadcast_filtration",
)
#scheduler.pause_job("broadcast_filtration")


scheduler.add_job(
    broadcast_sent_emails,
    "cron",
    #minute="*/1", works
    second="*/1",
    id="broadcast_sent_emails",
)
#scheduler.pause_job("broadcast_sent_emails")

scheduler.add_job(
    broadcast_utilite,
    "cron",
    #minute="*/1", works
    second="*/1",
    id="broadcast_utilite",
)
#scheduler.pause_job("broadcast_utilite")


scheduler.add_job(
    email_scheduler,
    "interval",
    seconds=20,
    id="email_scheduler",
)

logging.getLogger('apscheduler.executors.default').setLevel(logging.WARNING)
scheduler.start()
