// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) => ServerConfig(
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
      redisDB: StandardDatabaseConf.fromJson(
          json['REDIS_DB'] as Map<String, dynamic>),
      databases: (json['DATABASES'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, StandardDatabaseConf.fromJson(e as Map<String, dynamic>)),
      ),
      emailProviders: (json['EMAIL_PROVIDERS'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, EmailProviderConf.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ServerConfigToJson(ServerConfig instance) =>
    <String, dynamic>{
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
    };
