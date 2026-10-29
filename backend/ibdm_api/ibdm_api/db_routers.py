# Django's own apps (auth, contenttypes, sessions, admin) live in the main `ibdm` database.
# Without this, `users` (foreign key to auth.Group) cannot be migrated on a fresh database.
BUILTIN_APPS = {"auth", "contenttypes", "sessions", "admin", "messages"}
MAIN_DB = "ibdm"


class DB_Router:
    db_apps = {
        'ibdm': [
            'ibdm_api',
            'users',
            "emails",            
        ],
        "siroperie":[
            "siroperie",
        ],
        "filtration":[
            "filtration",
        ],
        "utilite":[
            "utilite",
        ],
        'automate': [
            'automate',
        ],
    }

    def db_for_read(self, model, **hints):
        if model._meta.app_label in BUILTIN_APPS:
            return MAIN_DB
        for db, apps in self.db_apps.items():
            if model._meta.app_label in apps:
                return db
        return None

    def db_for_write(self, model, **hints):
        return self.db_for_read(model, **hints)

    def allow_relation(self, obj1, obj2, **hints):
        return True

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if app_label in BUILTIN_APPS:
            return db == MAIN_DB
        if db in self.db_apps:
            return app_label in self.db_apps[db]
        return None
