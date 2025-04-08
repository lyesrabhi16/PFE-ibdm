// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redis_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedisInfo _$RedisInfoFromJson(Map<String, dynamic> json) => RedisInfo(
      usedMemory: (json['used_memory'] as num).toInt(),
      totalMemory: (json['total_memory'] as num).toInt(),
      freeMemory: (json['free_memory'] as num).toInt(),
      percent: (json['percent'] as num).toDouble(),
      totalKeys: (json['total_keys'] as num).toInt(),
      uptimeInSeconds: (json['uptime_in_seconds'] as num).toInt(),
      connectedClients: (json['connected_clients'] as num).toInt(),
    );

Map<String, dynamic> _$RedisInfoToJson(RedisInfo instance) => <String, dynamic>{
      'used_memory': instance.usedMemory,
      'total_memory': instance.totalMemory,
      'free_memory': instance.freeMemory,
      'percent': instance.percent,
      'total_keys': instance.totalKeys,
      'uptime_in_seconds': instance.uptimeInSeconds,
      'connected_clients': instance.connectedClients,
    };
