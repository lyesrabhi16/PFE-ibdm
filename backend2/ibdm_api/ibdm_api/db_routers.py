class DB_Router:
    db_apps = {
        'ibdm': [
            'ibdm_api',
            'users',            
        ],
        "siroperie":[
            "siroperie",
        ],
        'automate': [
            'automate',
        ],
    }

    def db_for_read(self, model, **hints):
        for db, apps in self.db_apps.items():
            if model._meta.app_label in apps:
                return db
        return None

    def db_for_write(self, model, **hints):
        for db, apps in self.db_apps.items():
            if model._meta.app_label in apps:
                return db
        return None

    def allow_relation(self, obj1, obj2, **hints):
        return True

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if db in self.db_apps:
            return app_label in self.db_apps[db]
        return None