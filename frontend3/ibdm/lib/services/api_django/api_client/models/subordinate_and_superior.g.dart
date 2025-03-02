// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subordinate_and_superior.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubordinateAndSuperior _$SubordinateAndSuperiorFromJson(
        Map<String, dynamic> json) =>
    SubordinateAndSuperior(
      superior: (json['superior'] as num).toInt(),
      subordinate: (json['subordinate'] as num).toInt(),
    );

Map<String, dynamic> _$SubordinateAndSuperiorToJson(
        SubordinateAndSuperior instance) =>
    <String, dynamic>{
      'superior': instance.superior,
      'subordinate': instance.subordinate,
    };
