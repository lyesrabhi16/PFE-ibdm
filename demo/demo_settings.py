"""Demo settings: same as the project's, but Django's built-in apps are migrated into the `ibdm` database.

The project's DB router never allows auth/contenttypes/sessions/admin to migrate anywhere, so
`users` (which has a foreign key to auth.Group) cannot be migrated on a fresh database.
"""
from ibdm_api.settings import *  # noqa: F401,F403
from ibdm_api.db_routers import DB_Router

BUILTIN_APPS = {"auth", "contenttypes", "sessions", "admin", "messages"}


class DemoRouter(DB_Router):
    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if app_label in BUILTIN_APPS:
            return db == "ibdm"
        return super().allow_migrate(db, app_label, model_name, **hints)

    def db_for_read(self, model, **hints):
        return super().db_for_read(model, **hints) or ("ibdm" if model._meta.app_label in BUILTIN_APPS else None)

    db_for_write = db_for_read


DATABASE_ROUTERS = ["demo_settings.DemoRouter"]
