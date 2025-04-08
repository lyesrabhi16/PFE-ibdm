// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'system_info.g.dart';

@JsonSerializable()
class SystemInfo {
  const SystemInfo({
    required this.os,
    required this.pythonVersion,
    required this.djangoVersion,
    required this.envMode,
    required this.debug,
    required this.hostname,
    required this.cpuArchitecture,
    required this.cpuModel,
    required this.cpuFrequency,
    required this.totalMemory,
    required this.availableMemory,
    required this.memoryPercentUsed,
    required this.cpuCount,
    required this.cpuPhysicalCount,
    required this.cpuPercent,
    required this.totalStorage,
    required this.usedStorage,
    required this.freeStorage,
    required this.diskPercentUsed,
    required this.diskIoReadCount,
    required this.diskIoWriteCount,
    required this.diskIoReadBytes,
    required this.diskIoWriteBytes,
    required this.uptime,
    required this.bootTime,
    required this.systemTime,
    required this.networkIoSent,
    required this.networkIoReceived,
    required this.ipAddresses,
  });
  
  factory SystemInfo.fromJson(Map<String, Object?> json) => _$SystemInfoFromJson(json);
  
  final String os;
  @JsonKey(name: 'python_version')
  final String pythonVersion;
  @JsonKey(name: 'django_version')
  final String djangoVersion;
  @JsonKey(name: 'env_mode')
  final String envMode;
  final bool debug;
  final String hostname;
  @JsonKey(name: 'cpu_architecture')
  final String cpuArchitecture;
  @JsonKey(name: 'cpu_model')
  final String cpuModel;
  @JsonKey(name: 'cpu_frequency')
  final double cpuFrequency;
  @JsonKey(name: 'total_memory')
  final int totalMemory;
  @JsonKey(name: 'available_memory')
  final int availableMemory;
  @JsonKey(name: 'memory_percent_used')
  final double memoryPercentUsed;
  @JsonKey(name: 'cpu_count')
  final int cpuCount;
  @JsonKey(name: 'cpu_physical_count')
  final int cpuPhysicalCount;
  @JsonKey(name: 'cpu_percent')
  final double cpuPercent;
  @JsonKey(name: 'total_storage')
  final int totalStorage;
  @JsonKey(name: 'used_storage')
  final int usedStorage;
  @JsonKey(name: 'free_storage')
  final int freeStorage;
  @JsonKey(name: 'disk_percent_used')
  final double diskPercentUsed;
  @JsonKey(name: 'disk_io_read_count')
  final int diskIoReadCount;
  @JsonKey(name: 'disk_io_write_count')
  final int diskIoWriteCount;
  @JsonKey(name: 'disk_io_read_bytes')
  final int diskIoReadBytes;
  @JsonKey(name: 'disk_io_write_bytes')
  final int diskIoWriteBytes;
  final double uptime;
  @JsonKey(name: 'boot_time')
  final String bootTime;
  @JsonKey(name: 'system_time')
  final String systemTime;
  @JsonKey(name: 'network_io_sent')
  final int networkIoSent;
  @JsonKey(name: 'network_io_received')
  final int networkIoReceived;
  @JsonKey(name: 'ip_addresses')
  final Map<String, String> ipAddresses;

  Map<String, Object?> toJson() => _$SystemInfoToJson(this);
}
