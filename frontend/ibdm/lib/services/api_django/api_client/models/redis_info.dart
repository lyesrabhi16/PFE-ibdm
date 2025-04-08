// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'redis_info.g.dart';

@JsonSerializable()
class RedisInfo {
  const RedisInfo({
    required this.usedMemory,
    required this.totalMemory,
    required this.freeMemory,
    required this.percent,
    required this.totalKeys,
    required this.uptimeInSeconds,
    required this.connectedClients,
  });
  
  factory RedisInfo.fromJson(Map<String, Object?> json) => _$RedisInfoFromJson(json);
  
  @JsonKey(name: 'used_memory')
  final int usedMemory;
  @JsonKey(name: 'total_memory')
  final int totalMemory;
  @JsonKey(name: 'free_memory')
  final int freeMemory;
  final double percent;
  @JsonKey(name: 'total_keys')
  final int totalKeys;
  @JsonKey(name: 'uptime_in_seconds')
  final int uptimeInSeconds;
  @JsonKey(name: 'connected_clients')
  final int connectedClients;

  Map<String, Object?> toJson() => _$RedisInfoToJson(this);
}
