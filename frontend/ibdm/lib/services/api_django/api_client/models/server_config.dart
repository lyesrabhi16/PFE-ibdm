// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'email_provider_conf.dart';
import 'standard_database_conf.dart';

part 'server_config.g.dart';

@JsonSerializable()
class ServerConfig {
  const ServerConfig({
    required this.envMode,
    required this.debug,
    required this.version,
    required this.systemMonitorDBTimeout,
    required this.allowedHosts,
    required this.csrfTrustedOrigins,
    required this.logTOFiles,
    required this.serverDBConnectionCheckTimeout,
    required this.redisDB,
    required this.databases,
    required this.emailProviders,
    this.dataStoppedWaitSeconds = 600,
    this.logSizeLimit = 100,
    this.countOFLogsTOKeep = 10,
  });
  
  factory ServerConfig.fromJson(Map<String, Object?> json) => _$ServerConfigFromJson(json);
  
  @JsonKey(name: 'ENV_MODE')
  final dynamic envMode;
  @JsonKey(name: 'DEBUG')
  final bool? debug;
  @JsonKey(name: 'VERSION')
  final String? version;
  @JsonKey(name: 'SYSTEM_MONITOR_DB_TIMEOUT')
  final int? systemMonitorDBTimeout;
  @JsonKey(name: 'ALLOWED_HOSTS')
  final List<String>? allowedHosts;
  @JsonKey(name: 'CSRF_TRUSTED_ORIGINS')
  final List<String>? csrfTrustedOrigins;
  @JsonKey(name: 'LOG_TO_FILES')
  final bool? logTOFiles;
  @JsonKey(name: 'SERVER_DB_CONNECTION_CHECK_TIMEOUT')
  final int? serverDBConnectionCheckTimeout;
  @JsonKey(name: 'DATA_STOPPED_WAIT_SECONDS')
  final int dataStoppedWaitSeconds;
  @JsonKey(name: 'REDIS_DB')
  final StandardDatabaseConf? redisDB;
  @JsonKey(name: 'DATABASES')
  final Map<String, StandardDatabaseConf>? databases;
  @JsonKey(name: 'EMAIL_PROVIDERS')
  final Map<String, EmailProviderConf>? emailProviders;
  @JsonKey(name: 'LOG_SIZE_LIMIT')
  final int logSizeLimit;
  @JsonKey(name: 'COUNT_OF_LOGS_TO_KEEP')
  final int countOFLogsTOKeep;

  Map<String, Object?> toJson() => _$ServerConfigToJson(this);
}
