import logging
from apscheduler.schedulers.twisted import TwistedScheduler
from filtration.consumers import FiltrationConsumer
from api_v1.broadcasts.filtration_broadcast import broadcast_filtration
from api_v1.broadcasts.sucre_broadcast import broadcast_sucre
from api_v1.broadcasts.sent_emails_broadcast import broadcast_sent_emails
from api_v1.broadcasts.utilite_broadcast import broadcast_utilite
from api_v1.emails.emails_scheduler import email_scheduler
from siroperie.consumers import SucreConsumer

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
#scheduler.pause_job("broadcast_sucre")


scheduler.add_job(
    email_scheduler,
    "interval",
    seconds=20,
    id="email_scheduler",
)

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


logging.getLogger('apscheduler.executors.default').setLevel(logging.WARNING)
scheduler.start()
