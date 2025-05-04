// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'redis_info.dart';

part 'redis_database.g.dart';

@JsonSerializable()
class RedisDatabase {
  const RedisDatabase({
    required this.state,
    required this.info,
  });
  
  factory RedisDatabase.fromJson(Map<String, Object?> json) => _$RedisDatabaseFromJson(json);
  
  final String state;
  final Map<String, RedisInfo>? info;

  Map<String, Object?> toJson() => _$RedisDatabaseToJson(this);
}
