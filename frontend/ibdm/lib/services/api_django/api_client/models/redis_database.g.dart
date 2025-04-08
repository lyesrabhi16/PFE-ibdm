// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redis_database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedisDatabase _$RedisDatabaseFromJson(Map<String, dynamic> json) =>
    RedisDatabase(
      state: json['state'] as String,
      info: (json['info'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, RedisInfo.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$RedisDatabaseToJson(RedisDatabase instance) =>
    <String, dynamic>{
      'state': instance.state,
      'info': instance.info,
    };
