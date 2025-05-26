from rest_framework import serializers

from api_v1.constants import ErrorCodes
from api_v1.env import EnvModes

class ErrorResponseSerializer(serializers.Serializer):
    status = serializers.CharField()
    code = serializers.ChoiceField(choices=ErrorCodes.getChoices())

class SuccessResponseSerializer(serializers.Serializer):
    status = serializers.CharField()
    message = serializers.CharField()

class FeedMetaDataSerializer(serializers.Serializer):
    start_date = serializers.DateTimeField()
    end_date = serializers.DateTimeField()



class SystemInfoSerializer(serializers.Serializer):
    os = serializers.CharField()
    python_version = serializers.CharField()
    django_version = serializers.CharField()
    env_mode = serializers.CharField()
    debug = serializers.BooleanField()
    hostname = serializers.CharField()
    cpu_architecture = serializers.CharField()
    cpu_model = serializers.CharField()
    cpu_frequency = serializers.FloatField()
    total_memory = serializers.IntegerField()
    available_memory = serializers.IntegerField()
    memory_percent_used = serializers.FloatField()
    cpu_count = serializers.IntegerField()
    cpu_physical_count = serializers.IntegerField()
    cpu_percent = serializers.FloatField()
    total_storage = serializers.IntegerField()
    used_storage = serializers.IntegerField()
    free_storage = serializers.IntegerField()
    disk_percent_used = serializers.FloatField()
    disk_io_read_count = serializers.IntegerField()
    disk_io_write_count = serializers.IntegerField()
    disk_io_read_bytes = serializers.IntegerField()
    disk_io_write_bytes = serializers.IntegerField()
    uptime = serializers.FloatField()
    boot_time = serializers.CharField()
    system_time = serializers.CharField()
    network_io_sent = serializers.IntegerField()
    network_io_received = serializers.IntegerField()
    ip_addresses = serializers.DictField(child=serializers.CharField())


class DatabaseStorageInfoSerializer(serializers.Serializer):
    used = serializers.IntegerField()
    available = serializers.IntegerField()
    total = serializers.IntegerField()
    percent = serializers.FloatField()


class RedisInfoSerializer(serializers.Serializer):
    used_memory = serializers.IntegerField()
    total_memory = serializers.IntegerField()
    free_memory = serializers.IntegerField()
    percent = serializers.FloatField()
    total_keys = serializers.IntegerField()
    uptime_in_seconds = serializers.IntegerField()
    connected_clients = serializers.IntegerField()


class StandardDatabaseSerializer(serializers.Serializer):
    state = serializers.CharField()
    info = serializers.DictField(child=DatabaseStorageInfoSerializer(), allow_null=True)
    query = serializers.CharField(allow_null=True, required=False)


class RedisDatabaseSerializer(serializers.Serializer):
    state = serializers.CharField()
    info = serializers.DictField(child=RedisInfoSerializer(), allow_null=True)


class DatabasesSerializer(serializers.Serializer):
    ibdm = StandardDatabaseSerializer()
    siroperie = StandardDatabaseSerializer()
    filtration = StandardDatabaseSerializer()
    utilite = StandardDatabaseSerializer()
    ibdm_redis = RedisDatabaseSerializer()


class SystemStatusSerializer(serializers.Serializer):
    status = serializers.CharField()
    version = serializers.CharField()
    env = serializers.CharField()
    debug = serializers.BooleanField()
    description = serializers.CharField()
    last_updated = serializers.DateTimeField()
    elapsed_time = serializers.CharField()
    system_info_elapsed_time = serializers.CharField()
    databases_elapsed_time = serializers.CharField()
    system_info = SystemInfoSerializer()
    databases = DatabasesSerializer()


class StandardDatabaseConfSerializer(serializers.Serializer):
    ENGINE = serializers.CharField(allow_null=True, required=False)
    NAME = serializers.CharField(allow_null=True, required=False)
    USER = serializers.CharField(allow_null=True, required=False)
    PASSWORD = serializers.CharField(allow_null=True, required=False)
    HOST = serializers.CharField(allow_null=True, required=False)
    PORT = serializers.CharField(allow_null=True, required=False)
    OPTIONS =serializers.DictField(allow_null=True, required=False)

class EmailProviderConfSerializer(serializers.Serializer):
    HOST = serializers.CharField()
    PORT = serializers.IntegerField()
    USE_TLS = serializers.BooleanField()
    USER = serializers.CharField()
    PASSWORD = serializers.CharField()
    EMAIL_OF_SENDER = serializers.CharField()

class ServerConfigSerializer(serializers.Serializer):
    SECRET_KEY = serializers.CharField(allow_null=True, write_only=True, required=False)
    ENV_MODE = serializers.ChoiceField(allow_null=True,choices=list(map(lambda x: (x, x), [EnvModes.PRODUCTION, EnvModes.DEVELOPMENT])))
    DEBUG = serializers.BooleanField(allow_null=True)
    VERSION = serializers.CharField(allow_null=True)
    SYSTEM_MONITOR_DB_TIMEOUT = serializers.IntegerField(allow_null=True)
    ALLOWED_HOSTS = serializers.ListField(child=serializers.CharField(), allow_null=True)
    CSRF_TRUSTED_ORIGINS = serializers.ListField(child=serializers.CharField(), allow_null=True)
    LOG_TO_FILES = serializers.BooleanField(allow_null=True)
    SERVER_DB_CONNECTION_CHECK_TIMEOUT = serializers.IntegerField(allow_null=True)
    DATA_STOPPED_WAIT_SECONDS = serializers.IntegerField(allow_null=True, required=False, default=600)  # seconds to wait for data to be inserted before alerting of stop
    REDIS_DB = StandardDatabaseConfSerializer(allow_null=True)
    DATABASES = serializers.DictField(child=StandardDatabaseConfSerializer(), allow_null=True)
    EMAIL_PROVIDERS = serializers.DictField(child=EmailProviderConfSerializer(), allow_null=True)
    LOG_SIZE_LIMIT = serializers.IntegerField(allow_null=True, required=False, default=100)  # 100 MB default log size limit
    COUNT_OF_LOGS_TO_KEEP = serializers.IntegerField(allow_null=True, required=False, default=10)  # 10 Log files for each log type

class StartEndDatesSerializer(serializers.Serializer):
    start_date = serializers.DateTimeField()
    end_date = serializers.DateTimeField()