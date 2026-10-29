"""Append a new synthetic reading to every plant table every few seconds so the dashboards stay 'live'."""
import os
import random
import sys
import time
from datetime import datetime

sys.path.insert(0, os.getcwd())
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ibdm_api.settings")
import django  # noqa: E402

django.setup()

# The API process runs the scheduler (monitors, alert e-mails); a second copy here would send everything twice.
try:
    from api_v1.scheduler import scheduler as _scheduler
    _scheduler.shutdown(wait=False)
except Exception:
    pass
from django.apps import apps  # noqa: E402
from ibdm_api.db_routers import DB_Router  # noqa: E402
import profiles  # noqa: E402

INTERVAL = float(os.environ.get("SIMULATE_INTERVAL", "10"))
rng = random.Random()
router = DB_Router()
models = [m for m in apps.get_models() if not m._meta.managed and m._meta.pk.get_internal_type() == "DateTimeField"]

while True:
    for model in models:
        db = router.db_for_write(model)
        try:
            last = model.objects.using(db).order_by("-date").first()
            if last is None:  # seeding not finished yet
                continue
            prev = {f: getattr(last, f) for f in profiles.table_fields(model)}
            ts = datetime.now().replace(microsecond=0)
            if ts <= last.date:
                continue
            row = profiles.compute_row(model, ts, prev, INTERVAL / 60, rng)
            model.objects.using(db).create(date=ts, **row)
        except Exception as exc:  # tables may not exist yet
            print("simulate:", model.__name__, type(exc).__name__, str(exc)[:80], flush=True)
    time.sleep(INTERVAL)
