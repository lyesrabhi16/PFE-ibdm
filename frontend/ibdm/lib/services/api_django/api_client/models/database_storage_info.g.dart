// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_storage_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatabaseStorageInfo _$DatabaseStorageInfoFromJson(Map<String, dynamic> json) =>
    DatabaseStorageInfo(
      used: (json['used'] as num).toInt(),
      available: (json['available'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      percent: (json['percent'] as num).toDouble(),
    );

Map<String, dynamic> _$DatabaseStorageInfoToJson(
        DatabaseStorageInfo instance) =>
    <String, dynamic>{
      'used': instance.used,
      'available': instance.available,
      'total': instance.total,
      'percent': instance.percent,
    };
