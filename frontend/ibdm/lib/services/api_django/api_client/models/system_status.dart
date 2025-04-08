// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:ibdm/utils/helpers/logger.dart';
import 'package:json_annotation/json_annotation.dart';

import 'databases.dart';
import 'system_info.dart';

part 'system_status.g.dart';

@JsonSerializable()
class SystemStatus {
  const SystemStatus({
    required this.status,
    required this.version,
    required this.env,
    required this.debug,
    required this.description,
    required this.lastUpdated,
    required this.elapsedTime,
    required this.systemInfoElapsedTime,
    required this.databasesElapsedTime,
    required this.systemInfo,
    required this.databases,
  });
  
  factory SystemStatus.fromJson(Map<String, Object?> json) => _$SystemStatusFromJson(json);
  
  final String status;
  final String version;
  final String env;
  final bool debug;
  final String description;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  @JsonKey(name: 'elapsed_time')
  final String elapsedTime;
  @JsonKey(name: 'system_info_elapsed_time')
  final String systemInfoElapsedTime;
  @JsonKey(name: 'databases_elapsed_time')
  final String databasesElapsedTime;
  @JsonKey(name: 'system_info')
  final SystemInfo systemInfo;
  final Databases databases;

  Map<String, Object?> toJson() => _$SystemStatusToJson(this);
}
