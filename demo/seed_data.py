"""Seed demo data: users with avatars, 30 days of sensor history, email schedules/alerts, and sent reports."""
import os
import random
import socket
import sys
import time
from datetime import datetime, timedelta

from django.apps import apps
from django.contrib.auth.models import Group
from django.core.files import File
from tenacity import stop_after_attempt, wait_fixed

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import profiles  # noqa: E402
from emails.models import AlertEmail, EmailSchedule, sentEmail  # noqa: E402
from ibdm_api.db_routers import DB_Router  # noqa: E402
from users.models import Role, User  # noqa: E402

DEMO_DIR = os.path.dirname(os.path.abspath(__file__))
PASSWORD = "Demo_Passw0rd!"
HISTORY_DAYS, STEP_MIN = 30, 10

# ---- users -----------------------------------------------------------------------------------------------
PEOPLE = [
    # email, first, last, role (group), avatar, phone
    ("admin@ibdm.demo", "Samir", "Bensalem", "ADMIN_SYSTEM", "samir-bensalem", "0550 12 34 01"),
    ("amel.haddad@ibdm.demo", "Amel", "Haddad", "PRODUCTION", "amel-haddad", "0550 12 34 02"),
    ("karim.mebarki@ibdm.demo", "Karim", "Mebarki", "MAINTENANCE", "karim-mebarki", "0550 12 34 03"),
    ("nadia.cherif@ibdm.demo", "Nadia", "Cherif", "QUALITE", "nadia-cherif", "0550 12 34 04"),
    ("yacine.ouldali@ibdm.demo", "Yacine", "Ould Ali", "PRODUCTION", "yacine-ould-ali", "0550 12 34 05"),
    ("lina.boudiaf@ibdm.demo", "Lina", "Boudiaf", "LOGISTIQUE", "lina-boudiaf", "0550 12 34 06"),
    ("rachid.zerrouki@ibdm.demo", "Rachid", "Zerrouki", "MAINTENANCE", "rachid-zerrouki", "0550 12 34 07"),
    ("sara.khelifi@ibdm.demo", "Sara", "Khelifi", "QUALITE", "sara-khelifi", "0550 12 34 08"),
]

users = {}
for email, first, last, group_name, avatar, phone in PEOPLE:
    user = User.objects.filter(email=email).first()
    if user is None:
        if group_name == "ADMIN_SYSTEM":
            user = User.objects.create_superuser(email, PASSWORD)
        else:
            group = Group.objects.get_or_create(name=group_name)[0]
            role = Role.objects.get_or_create(group=group, defaults={"is_admin": False})[0]
            user = User.objects.create_user(email, PASSWORD, role)
        print("created user", email)
    # The profile is (re)applied on every start, so a run interrupted after the account was created still ends up complete.
    for field, value in (("first_name", first), ("last_name", last), ("phone_number", phone),
                         ("username", f"{first}.{last}".lower().replace(" ", ""))):
        setattr(user, field, value)
    if not user.avatar or not user.avatar.storage.exists(user.avatar.name):  # also covers a file lost with the container
        with open(os.path.join(DEMO_DIR, "avatars", avatar + ".png"), "rb") as f:
            user.avatar.save(avatar + ".png", File(f), save=False)
    user.save()
    users[email] = user

# ---- sensor history --------------------------------------------------------------------------------------
rng = random.Random(2026)
now = datetime.now().replace(second=0, microsecond=0)
now -= timedelta(minutes=now.minute % STEP_MIN)
router = DB_Router()
# Regular 10-minute grid, plus the readings the app's "hours/days/weeks/months" graph precisions look for
# (hh:59:57 every hour, 00:00:30 every day, e.g. get_midnight_value and the end-of-period windows in api_v1/utils.py).
start = (now - timedelta(days=HISTORY_DAYS)).replace(hour=0, minute=0)
timestamps = set()
t = start
while t <= now:
    timestamps.add(t)
    timestamps.add(t.replace(minute=59, second=57))
    if t.hour == 0 and t.minute == 0:
        timestamps.add(t.replace(second=30))
    t += timedelta(minutes=STEP_MIN)
timestamps = sorted(ts for ts in timestamps if ts <= now)

for model in apps.get_models():
    if model._meta.managed or model._meta.pk.get_internal_type() != "DateTimeField":
        continue
    db = router.db_for_write(model)
    if not db or model.objects.using(db).exists():
        continue
    rows, prev, last_ts = [], None, None
    for ts in timestamps:
        step = STEP_MIN if last_ts is None else max((ts - last_ts).total_seconds() / 60, 0.1)
        prev = profiles.compute_row(model, ts, prev, step, rng)
        rows.append(model(date=ts, **prev))
        last_ts = ts
    model.objects.using(db).bulk_create(rows, batch_size=200)
    print("seeded", model._meta.label, len(rows))

# ---- email schedules, alerts and sent reports -----------------------------------------------------------
recipients = [users["admin@ibdm.demo"], users["amel.haddad@ibdm.demo"], users["nadia.cherif@ibdm.demo"]]
tomorrow_7 = (now + timedelta(days=1)).replace(hour=7, minute=0)
# Each schedule / alert is created or completed on its own, so a restart repairs whatever an interrupted run left behind.
schedules = []
for rapport, interval in (("inventaire-sucre", "jour"), ("filtration", "jour"), ("co2_ifruit", "semaine"), ("utilite", "mois")):
    schedule, created = EmailSchedule.objects.get_or_create(
        rapport=rapport,
        defaults=dict(temps_envoi=tomorrow_7.time(), interval=interval,
                      interval_manual={"jour": 1, "semaine": 7, "mois": 30}[interval], next_run_time=tomorrow_7),
    )
    schedule.scheduled_users.set(recipients)
    schedules.append(schedule)
    if created:
        print("created email schedule", rapport)

sucre, _ = AlertEmail.objects.get_or_create(
    monitored_value="sucre.total",
    defaults=dict(monitor_type="DESC", danger_point=100000, warning_point=650000,
                  danger_reminder_interval=1, warning_reminder_interval=7,
                  custom_alert_message="Le stock total de sucre passe sous le seuil d'avertissement : planifier une commande de citernes."))
sucre.send_to_users.set([users["admin@ibdm.demo"], users["lina.boudiaf@ibdm.demo"]])
niveau, _ = AlertEmail.objects.get_or_create(
    monitored_value="niveau.niv_os7",
    defaults=dict(monitor_type="DESC", danger_point=9.5, warning_point=9.8,
                  danger_reminder_interval=1, warning_reminder_interval=7,
                  custom_alert_message="Niveau OS7 bas : intervention de maintenance requise."))
niveau.send_to_roles.set([Role.objects.get(group__name="MAINTENANCE")])


def wait_for_smtp(timeout=90):
    """The mail server may start a little after the API container."""
    from django.conf import settings
    for provider in settings.EMAIL_PROVIDERS:
        deadline = time.time() + timeout
        while True:
            try:
                socket.create_connection((provider.host, provider.port), timeout=3).close()
                break
            except OSError:
                if time.time() > deadline:
                    raise
                time.sleep(2)


def send_report(schedule):
    """Send one schedule's report synchronously, so it is delivered and recorded before the start-up continues."""
    from api_v1.emails.emails_scheduler import getHtmlMessage, sendEmailWithFile
    people = set(schedule.scheduled_users.all())
    for role in schedule.scheduled_roles.all():
        people.update(User.objects.filter(role=role))
    built = getHtmlMessage(schedule)
    if not isinstance(built, tuple):  # the report builder returns a plain message when there is no data
        print("no data for report", schedule.rapport, "-", built)
        return
    message, file, subject = built
    # a few quick retries instead of the app's hour-long retry loop, which must not block the start-up
    sendEmailWithFile.retry_with(stop=stop_after_attempt(5), wait=wait_fixed(3))(
        file=file, users=people, email=schedule,
        subject=f"IBDM {subject}", body=message, to=sorted(u.email for u in people))


if os.environ.get("DEMO_SEND_REPORTS", "1") == "1":
    pending = [s for s in schedules if not sentEmail.objects.filter(schedule=s).exists()]
    if pending:
        wait_for_smtp()
        for schedule in pending:
            send_report(schedule)
            print("report sent:", schedule.rapport)
