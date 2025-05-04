// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'databases.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Databases _$DatabasesFromJson(Map<String, dynamic> json) => Databases(
      ibdm: StandardDatabase.fromJson(json['ibdm'] as Map<String, dynamic>),
      siroperie:
          StandardDatabase.fromJson(json['siroperie'] as Map<String, dynamic>),
      filtration:
          StandardDatabase.fromJson(json['filtration'] as Map<String, dynamic>),
      utilite:
          StandardDatabase.fromJson(json['utilite'] as Map<String, dynamic>),
      ibdmRedis:
          RedisDatabase.fromJson(json['ibdm_redis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DatabasesToJson(Databases instance) => <String, dynamic>{
      'ibdm': instance.ibdm,
      'siroperie': instance.siroperie,
      'filtration': instance.filtration,
      'utilite': instance.utilite,
      'ibdm_redis': instance.ibdmRedis,
    };
