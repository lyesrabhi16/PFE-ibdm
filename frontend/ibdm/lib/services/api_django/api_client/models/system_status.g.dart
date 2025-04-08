// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemStatus _$SystemStatusFromJson(Map<String, dynamic> json) {
  final s = SystemStatus(
    status: json['status'] as String,
    version: json['version'] as String,
    env: json['env'] as String,
    debug: json['debug'] as bool,
    description: json['description'] as String,
    lastUpdated: DateTime.parse(json['last_updated'] as String),
    elapsedTime: json['elapsed_time'] as String,
    systemInfoElapsedTime: json['system_info_elapsed_time'] as String,
    databasesElapsedTime: json['databases_elapsed_time'] as String,
    systemInfo:
        SystemInfo.fromJson(json['system_info'] as Map<String, dynamic>),
    databases: Databases.fromJson(json['databases'] as Map<String, dynamic>),
  );
  return s;
}

Map<String, dynamic> _$SystemStatusToJson(SystemStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'env': instance.env,
      'debug': instance.debug,
      'description': instance.description,
      'last_updated': instance.lastUpdated.toIso8601String(),
      'elapsed_time': instance.elapsedTime,
      'system_info_elapsed_time': instance.systemInfoElapsedTime,
      'databases_elapsed_time': instance.databasesElapsedTime,
      'system_info': instance.systemInfo,
      'databases': instance.databases,
    };
