"""Seed demo data: an admin user and ~20 h of synthetic 5-minute sensor readings for each plant table."""
import math
import random
from datetime import timedelta

from django.apps import apps
from django.db import connections
from django.utils import timezone

from ibdm_api.db_routers import DB_Router
from users.models import User

ADMIN_EMAIL, ADMIN_PASSWORD = "admin@ibdm.demo", "Demo_Passw0rd!"
if not User.objects.filter(email=ADMIN_EMAIL).exists():
    User.objects.create_superuser(ADMIN_EMAIL, ADMIN_PASSWORD)
    print("created", ADMIN_EMAIL)

random.seed(42)
now = timezone.now().replace(second=0, microsecond=0)
router = DB_Router()
for model in apps.get_models():
    if model._meta.managed or not model._meta.pk.get_internal_type() == "DateTimeField":
        continue
    db = router.db_for_write(model)
    if not db or model.objects.using(db).exists():
        continue
    floats = [f for f in model._meta.concrete_fields if f.get_internal_type() == "FloatField"]
    base = {f.name: random.uniform(5, 100) for f in floats}
    rows = []
    for i in range(240):
        ts = now - timedelta(minutes=5 * (239 - i))
        values = {f.name: round(max(0.0, base[f.name] * (1 + 0.15 * math.sin(i / 20 + hash(f.name) % 7)) + random.gauss(0, 1.5)), 2)
                  for f in floats}
        rows.append(model(date=ts, **values))
    model.objects.using(db).bulk_create(rows, batch_size=100)
    print("seeded", model._meta.label, len(rows))
