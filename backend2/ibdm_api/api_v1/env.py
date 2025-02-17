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

    # automate db
    DATABASE_AUTOMATE_NAME = config("DATABASE_AUTOMATE_NAME")
    DATABASE_AUTOMATE_USER = config("DATABASE_AUTOMATE_USER")
    DATABASE_AUTOMATE_PASSWORD = config("DATABASE_AUTOMATE_PASSWORD")
    DATABASE_AUTOMATE_HOST = config("DATABASE_AUTOMATE_HOST")
    DATABASE_AUTOMATE_PORT = config("DATABASE_AUTOMATE_PORT")
    