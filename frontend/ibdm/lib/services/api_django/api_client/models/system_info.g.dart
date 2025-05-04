// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) => SystemInfo(
      os: json['os'] as String,
      pythonVersion: json['python_version'] as String,
      djangoVersion: json['django_version'] as String,
      envMode: json['env_mode'] as String,
      debug: json['debug'] as bool,
      hostname: json['hostname'] as String,
      cpuArchitecture: json['cpu_architecture'] as String,
      cpuModel: json['cpu_model'] as String,
      cpuFrequency: (json['cpu_frequency'] as num).toDouble(),
      totalMemory: (json['total_memory'] as num).toInt(),
      availableMemory: (json['available_memory'] as num).toInt(),
      memoryPercentUsed: (json['memory_percent_used'] as num).toDouble(),
      cpuCount: (json['cpu_count'] as num).toInt(),
      cpuPhysicalCount: (json['cpu_physical_count'] as num).toInt(),
      cpuPercent: (json['cpu_percent'] as num).toDouble(),
      totalStorage: (json['total_storage'] as num).toInt(),
      usedStorage: (json['used_storage'] as num).toInt(),
      freeStorage: (json['free_storage'] as num).toInt(),
      diskPercentUsed: (json['disk_percent_used'] as num).toDouble(),
      diskIoReadCount: (json['disk_io_read_count'] as num).toInt(),
      diskIoWriteCount: (json['disk_io_write_count'] as num).toInt(),
      diskIoReadBytes: (json['disk_io_read_bytes'] as num).toInt(),
      diskIoWriteBytes: (json['disk_io_write_bytes'] as num).toInt(),
      uptime: (json['uptime'] as num).toDouble(),
      bootTime: json['boot_time'] as String,
      systemTime: json['system_time'] as String,
      networkIoSent: (json['network_io_sent'] as num).toInt(),
      networkIoReceived: (json['network_io_received'] as num).toInt(),
      ipAddresses: Map<String, String>.from(json['ip_addresses'] as Map),
    );

Map<String, dynamic> _$SystemInfoToJson(SystemInfo instance) =>
    <String, dynamic>{
      'os': instance.os,
      'python_version': instance.pythonVersion,
      'django_version': instance.djangoVersion,
      'env_mode': instance.envMode,
      'debug': instance.debug,
      'hostname': instance.hostname,
      'cpu_architecture': instance.cpuArchitecture,
      'cpu_model': instance.cpuModel,
      'cpu_frequency': instance.cpuFrequency,
      'total_memory': instance.totalMemory,
      'available_memory': instance.availableMemory,
      'memory_percent_used': instance.memoryPercentUsed,
      'cpu_count': instance.cpuCount,
      'cpu_physical_count': instance.cpuPhysicalCount,
      'cpu_percent': instance.cpuPercent,
      'total_storage': instance.totalStorage,
      'used_storage': instance.usedStorage,
      'free_storage': instance.freeStorage,
      'disk_percent_used': instance.diskPercentUsed,
      'disk_io_read_count': instance.diskIoReadCount,
      'disk_io_write_count': instance.diskIoWriteCount,
      'disk_io_read_bytes': instance.diskIoReadBytes,
      'disk_io_write_bytes': instance.diskIoWriteBytes,
      'uptime': instance.uptime,
      'boot_time': instance.bootTime,
      'system_time': instance.systemTime,
      'network_io_sent': instance.networkIoSent,
      'network_io_received': instance.networkIoReceived,
      'ip_addresses': instance.ipAddresses,
    };
