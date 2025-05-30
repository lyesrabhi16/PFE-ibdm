// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfigRequest _$ServerConfigRequestFromJson(Map<String, dynamic> json) =>
    ServerConfigRequest(
      envMode: json['ENV_MODE'],
      debug: json['DEBUG'] as bool?,
      version: json['VERSION'] as String?,
      systemMonitorDBTimeout:
          (json['SYSTEM_MONITOR_DB_TIMEOUT'] as num?)?.toInt(),
      allowedHosts: (json['ALLOWED_HOSTS'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      csrfTrustedOrigins: (json['CSRF_TRUSTED_ORIGINS'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      logTOFiles: json['LOG_TO_FILES'] as bool?,
      serverDBConnectionCheckTimeout:
          (json['SERVER_DB_CONNECTION_CHECK_TIMEOUT'] as num?)?.toInt(),
      redisDB: json['REDIS_DB'] == null
          ? null
          : StandardDatabaseConfRequest.fromJson(
              json['REDIS_DB'] as Map<String, dynamic>),
      databases: (json['DATABASES'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, StandardDatabaseConfRequest.fromJson(e as Map<String, dynamic>)),
      ),
      emailProviders: (json['EMAIL_PROVIDERS'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, EmailProviderConfRequest.fromJson(e as Map<String, dynamic>)),
      ),
      logSizeLimit: (json['LOG_SIZE_LIMIT'] as num?)?.toInt() ?? 100,
      countOFLogsTOKeep: (json['COUNT_OF_LOGS_TO_KEEP'] as num?)?.toInt() ?? 10,
      dataStoppedWaitSeconds:
          (json['DATA_STOPPED_WAIT_SECONDS'] as num?)?.toInt() ?? 600,
      secretKey: json['SECRET_KEY'] as String?,
    );

Map<String, dynamic> _$ServerConfigRequestToJson(
        ServerConfigRequest instance) =>
    <String, dynamic>{
      'SECRET_KEY': instance.secretKey,
      'ENV_MODE': instance.envMode,
      'DEBUG': instance.debug,
      'VERSION': instance.version,
      'SYSTEM_MONITOR_DB_TIMEOUT': instance.systemMonitorDBTimeout,
      'ALLOWED_HOSTS': instance.allowedHosts,
      'CSRF_TRUSTED_ORIGINS': instance.csrfTrustedOrigins,
      'LOG_TO_FILES': instance.logTOFiles,
      'SERVER_DB_CONNECTION_CHECK_TIMEOUT':
          instance.serverDBConnectionCheckTimeout,
      'REDIS_DB': instance.redisDB,
      'DATABASES': instance.databases,
      'EMAIL_PROVIDERS': instance.emailProviders,
      'LOG_SIZE_LIMIT': instance.logSizeLimit,
      'COUNT_OF_LOGS_TO_KEEP': instance.countOFLogsTOKeep,
      'DATA_STOPPED_WAIT_SECONDS': instance.dataStoppedWaitSeconds,
    };
