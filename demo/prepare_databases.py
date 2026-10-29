"""Create the demo databases, apply migrations, create the unmanaged plant tables and seed data."""
import os
import sys
import time

import pyodbc

HOST, PWD = os.environ["DATABASE_IBDM_HOST"], os.environ["DATABASE_IBDM_PASSWORD"]
DBS = ["ibdm", "siroperie", "filtration", "utilite", "automate"]
CONN = ("DRIVER={ODBC Driver 18 for SQL Server};SERVER=%s,1433;UID=sa;PWD=%s;"
        "TrustServerCertificate=yes;DATABASE=master") % (HOST, PWD)


def wait_and_create_databases():
    for attempt in range(60):
        try:
            conn = pyodbc.connect(CONN, autocommit=True, timeout=5)
            break
        except pyodbc.Error:
            time.sleep(2)
    else:
        sys.exit("SQL Server not reachable")
    cur = conn.cursor()
    for name in DBS:
        cur.execute(f"IF DB_ID('{name}') IS NULL CREATE DATABASE [{name}]")
    conn.close()


wait_and_create_databases()

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ibdm_api.settings")
sys.path.insert(0, os.getcwd())
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import django  # noqa: E402

django.setup()

# The API process runs the scheduler (monitors, alert e-mails). Keep this one-shot setup process from running a second copy.
try:
    from api_v1.scheduler import scheduler as _scheduler
    _scheduler.shutdown(wait=False)
except Exception:
    pass
from django.apps import apps  # noqa: E402
from django.core.management import call_command  # noqa: E402
from django.db import connections  # noqa: E402
from ibdm_api.db_routers import DB_Router  # noqa: E402

for db in DBS:
    call_command("migrate", database=db, interactive=False, verbosity=0)

# Plant tables are `managed = False` (they pre-exist in production), so create them here.
for model in apps.get_models():
    if model._meta.managed:
        continue
    db = DB_Router().db_for_write(model)
    if not db:
        continue
    with connections[db].schema_editor() as editor:
        try:
            editor.create_model(model)
        except Exception as exc:  # table already exists on restart
            print("skip", model._meta.db_table, type(exc).__name__)

seed = os.path.join(os.path.dirname(__file__), "seed_data.py")
if os.path.exists(seed):
    exec(open(seed).read(), {"__name__": "__seed__", "__file__": seed})
print("Databases ready", flush=True)
sys.stdout.flush()
os._exit(0)  # do not wait for e-mail retry threads
