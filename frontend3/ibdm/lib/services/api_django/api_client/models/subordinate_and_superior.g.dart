// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subordinate_and_superior.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubordinateAndSuperior _$SubordinateAndSuperiorFromJson(
        Map<String, dynamic> json) =>
    SubordinateAndSuperior(
      url: json['url'] as String,
      superior: (json['superior'] as num).toInt(),
      subordinate: (json['subordinate'] as num).toInt(),
    );

Map<String, dynamic> _$SubordinateAndSuperiorToJson(
        SubordinateAndSuperior instance) =>
    <String, dynamic>{
      'url': instance.url,
      'superior': instance.superior,
      'subordinate': instance.subordinate,
    };
