// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subordinate_and_superior_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubordinateAndSuperiorRequest _$SubordinateAndSuperiorRequestFromJson(
        Map<String, dynamic> json) =>
    SubordinateAndSuperiorRequest(
      superior: (json['superior'] as num).toInt(),
      subordinate: (json['subordinate'] as num).toInt(),
    );

Map<String, dynamic> _$SubordinateAndSuperiorRequestToJson(
        SubordinateAndSuperiorRequest instance) =>
    <String, dynamic>{
      'superior': instance.superior,
      'subordinate': instance.subordinate,
    };
