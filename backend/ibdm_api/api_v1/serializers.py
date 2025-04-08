from rest_framework import serializers

from api_v1.constants import ErrorCodes

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
    info = serializers.DictField(child=DatabaseStorageInfoSerializer())
    query = serializers.CharField()


class RedisDatabaseSerializer(serializers.Serializer):
    state = serializers.CharField()
    info = serializers.DictField(child=RedisInfoSerializer())


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
    last_updated = serializers.DateTimeField(format="%Y-%m-%dT%H:%M:%S.%f")
    elapsed_time = serializers.CharField()
    system_info_elapsed_time = serializers.CharField()
    databases_elapsed_time = serializers.CharField()
    system_info = SystemInfoSerializer()
    databases = DatabasesSerializer()