from decouple import config, Choices
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
    DEBUG = config("DEBUG", default=True, cast=bool)
    VERSION = config("VERSION", default="1.0.0")
    SYSTEM_MONITOR_DB_TIMEOUT = config("SYSTEM_MONITOR_DB_TIMEOUT", default=3, cast=int)
    ALLOWED_HOSTS = config("ALLOWED_HOSTS", default="*", cast=lambda v: [s.strip() for s in v.split(",")])
    CSRF_TRUSTED_ORIGINS = config("CSRF_TRUSTED_ORIGINS", default="*", cast=lambda v: [s.strip() for s in v.split(",")])
    LOG_TO_FILES = config("LOG_TO_FILES", default=True, cast=bool)

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