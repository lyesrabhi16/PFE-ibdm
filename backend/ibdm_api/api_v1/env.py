import json
from decouple import config, Choices
from typing import Dict
from ibdm_api import settings as django_settings
from api_v1.env_utils import update_nested_dict, get_nested_dict_values, encrypt, decrypt
from copy import deepcopy

class EnvModes:
    DEVELOPMENT = "development"
    PRODUCTION = "production"

    @classmethod
    def getValues(cls):
        # Use a class method to dynamically retrieve all class variables
        return [value for name, value in cls.__dict__.items() if not callable(value) and not name.startswith("__")]

class Env:
    SECRET_KEY = config("SECRET_KEY")
    ENV_MODE = config("ENV_MODE", default="development", cast=Choices(EnvModes.getValues()))
    DEBUG = config("DEBUG", default=False, cast=bool)
    VERSION = config("VERSION", default="1.0.0")
    SYSTEM_MONITOR_DB_TIMEOUT = config("SYSTEM_MONITOR_DB_TIMEOUT", default=3, cast=int)
    ALLOWED_HOSTS = config("ALLOWED_HOSTS", default="*", cast=lambda v: [s.strip() for s in v.split(",")])
    CSRF_TRUSTED_ORIGINS = config("CSRF_TRUSTED_ORIGINS", default="https://localhost:8443", cast=lambda v: [s.strip() for s in v.split(",")])
    LOG_TO_FILES = config("LOG_TO_FILES", default=True, cast=bool)
    SERVER_DB_CONNECTION_CHECK_TIMEOUT = config("SERVER_DB_CONNECTION_CHECK_TIMEOUT", default=3, cast=int) # IN SECONDS

    # ibdm redis db
    DATABASE_IBDM_REDIS_HOST = config("DATABASE_IBDM_REDIS_HOST")
    DATABASE_IBDM_REDIS_PORT = config("DATABASE_IBDM_REDIS_PORT")

    # ibdm db
    DATABASE_IBDM_NAME = config("DATABASE_IBDM_NAME")
    DATABASE_IBDM_USER = config("DATABASE_IBDM_USER")
    DATABASE_IBDM_PASSWORD = config("DATABASE_IBDM_PASSWORD")
    DATABASE_IBDM_HOST = config("DATABASE_IBDM_HOST")
    DATABASE_IBDM_PORT = config("DATABASE_IBDM_PORT")

     # siroperie db
    DATABASE_SIROPERIE_NAME = config("DATABASE_SIROPERIE_NAME")
    DATABASE_SIROPERIE_USER = config("DATABASE_SIROPERIE_USER")
    DATABASE_SIROPERIE_PASSWORD = config("DATABASE_SIROPERIE_PASSWORD")
    DATABASE_SIROPERIE_HOST = config("DATABASE_SIROPERIE_HOST")
    DATABASE_SIROPERIE_PORT = config("DATABASE_SIROPERIE_PORT")

    # filtration db
    DATABASE_FILTRATION_NAME = config("DATABASE_FILTRATION_NAME")
    DATABASE_FILTRATION_USER = config("DATABASE_FILTRATION_USER")
    DATABASE_FILTRATION_PASSWORD = config("DATABASE_FILTRATION_PASSWORD")
    DATABASE_FILTRATION_HOST = config("DATABASE_FILTRATION_HOST")
    DATABASE_FILTRATION_PORT = config("DATABASE_FILTRATION_PORT")

    # filtration db
    DATABASE_UTILITE_NAME = config("DATABASE_UTILITE_NAME")
    DATABASE_UTILITE_USER = config("DATABASE_UTILITE_USER")
    DATABASE_UTILITE_PASSWORD = config("DATABASE_UTILITE_PASSWORD")
    DATABASE_UTILITE_HOST = config("DATABASE_UTILITE_HOST")
    DATABASE_UTILITE_PORT = config("DATABASE_UTILITE_PORT")

    # email smtp configuration
    EMAIL_HOST = config("EMAIL_HOST")
    EMAIL_USE_TLS = config("EMAIL_USE_TLS")
    EMAIL_PORT = config("EMAIL_PORT")
    EMAIL_HOST_USER = config("EMAIL_HOST_USER")
    EMAIL_HOST_PASSWORD = config("EMAIL_HOST_PASSWORD")
    EMAIL_OF_SENDER = config("EMAIL_OF_SENDER")

    # email smtp configuration
    EMAIL_HOST2 = config("EMAIL_HOST2", "None")
    EMAIL_USE_TLS2 = config("EMAIL_USE_TLS2", "None")
    EMAIL_PORT2 = config("EMAIL_PORT2", "None")
    EMAIL_HOST_USER2 = config("EMAIL_HOST_USER2", "None")
    EMAIL_HOST_PASSWORD2 = config("EMAIL_HOST_PASSWORD2", "None")
    EMAIL_OF_SENDER2 = config("EMAIL_OF_SENDER2", "None")

    def __init__(self):
        Env.load_settings_json()

    settings : Dict = {}
    settings_encrypted : Dict = {}
    SECRET_KEY = settings.get('SECRET_KEY') or config("SECRET_KEY")
    ENV_MODE = settings.get('ENV_MODE') or config("ENV_MODE", default="development", cast=Choices(EnvModes.getValues()))
    DEBUG = settings.get("DEBUG") or config("DEBUG", default=False, cast=bool)
    VERSION = settings.get('VERSION') or config("VERSION", default="1.0.0")
    SYSTEM_MONITOR_DB_TIMEOUT = settings.get('SYSTEM_MONITOR_DB_TIMEOUT') or config("SYSTEM_MONITOR_DB_TIMEOUT", default=3, cast=int)
    ALLOWED_HOSTS = settings.get('ALLOWED_HOSTS') or config("ALLOWED_HOSTS", default="*", cast=lambda v: [s.strip() for s in v.split(",")])
    CSRF_TRUSTED_ORIGINS = settings.get('CSRF_TRUSTED_ORIGINS') or config("CSRF_TRUSTED_ORIGINS", default="https://localhost:8443", cast=lambda v: [s.strip() for s in v.split(",")])
    LOG_TO_FILES = settings.get('LOG_TO_FILES') or config("LOG_TO_FILES", default=True, cast=bool)
    SERVER_DB_CONNECTION_CHECK_TIMEOUT = settings.get('SERVER_DB_CONNECTION_CHECK_TIMEOUT') or config("SERVER_DB_CONNECTION_CHECK_TIMEOUT", default=3, cast=int) # IN SECONDS

    REDIS_DB : Dict = dict((settings.get('REDIS_DB')) or config("REDIS_DB", default={},cast=dict) or {})
    DATABASES : Dict = dict(settings.get('DATABASES') or config("DATABASES", default={}, cast=dict) or {})
    EMAIL_PROVIDERS : Dict = dict(settings.get('EMAIL_PROVIDERS') or config("EMAIL_PROVIDERS", default={}, cast=dict) or {})

    @classmethod
    def load_settings_json(cls):
        
        json_file = django_settings.SETTINGS_JSON_FILE_PATH
        with open(json_file, "r+") as f:
            try:
                Env.settings = json.load(f)
                Env.settings_encrypted = deepcopy(Env.settings)
                Env.SECRET_KEY = Env.settings["SECRET_KEY"]
                for key_path in django_settings.SETTINGS_HASHED_FIELDS:
                    update_nested_dict(
                        Env.settings,
                        key_path,
                        decrypt,
                    )
                for key in Env.settings:
                    print("setting : ",key)
                    setattr(Env, key, Env.settings[key])
            except Exception as e:
                print("using env vars : ",e)
        with open(json_file, "w+") as f:
            data = {
                        "VERSION": Env.VERSION,
                        "SECRET_KEY": Env.SECRET_KEY,
                        "ENV_MODE" : Env.ENV_MODE,
                        "DEBUG" : Env.DEBUG,
                        "SYSTEM_MONITOR_DB_TIMEOUT" : Env.SYSTEM_MONITOR_DB_TIMEOUT,
                        "ALLOWED_HOSTS" : Env.ALLOWED_HOSTS,
                        "CSRF_TRUSTED_ORIGINS" : Env.CSRF_TRUSTED_ORIGINS,
                        "LOG_TO_FILES" : Env.LOG_TO_FILES,
                        "SERVER_DB_CONNECTION_CHECK_TIMEOUT" : Env.SERVER_DB_CONNECTION_CHECK_TIMEOUT,
                        "REDIS_DB": Env.REDIS_DB,
                        "DATABASES": Env.DATABASES,
                        "EMAIL_PROVIDERS": Env.EMAIL_PROVIDERS
                    }
            
            # replace all SETTINGS_HASHED_FIELDS values with encrypted values
            for key_path in django_settings.SETTINGS_HASHED_FIELDS:
                
                path_values = get_nested_dict_values(
                    Env.settings_encrypted,
                    key_path,
                )
                
                #print("PATH_VALUES:",path_values)
                for path, value in path_values:
                    if not isinstance(value, str) or not value.startswith("gAAAAAB"):
                        #print(f"valueOf({path}) not encrypted: {value}")
                        pass
                    else:
                        #print(f"valueOf({path}) is encrypted already")
                        def getEncryptedValue(v):
                            #print("getting encrypted value")
                            value = get_nested_dict_values(
                                Env.settings_encrypted,
                                path
                            )[0][1]
                            #print("ENCRYPTED_VALUE: ", value)
                            return value
                        #print("UPDATE PATH: ",path)
                        update_nested_dict(
                            data,
                            path,
                            getEncryptedValue,
                        )

                        #print("UPDATED")
        
            for key_path in django_settings.SETTINGS_HASHED_FIELDS:
                update_nested_dict(
                    data,
                    key_path,
                    encrypt,
                )
            f.write(
                json.dumps(
                    data, indent=4, default=str
                )
            )

        for key_path in django_settings.SETTINGS_HASHED_FIELDS:
            update_nested_dict(
                data,
                key_path,
                decrypt,
            ) 
        return Env.settings