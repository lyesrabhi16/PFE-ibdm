// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_subordinate_and_superior_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchedSubordinateAndSuperiorRequest
    _$PatchedSubordinateAndSuperiorRequestFromJson(Map<String, dynamic> json) =>
        PatchedSubordinateAndSuperiorRequest(
          superior: (json['superior'] as num).toInt(),
          subordinate: (json['subordinate'] as num).toInt(),
        );

Map<String, dynamic> _$PatchedSubordinateAndSuperiorRequestToJson(
        PatchedSubordinateAndSuperiorRequest instance) =>
    <String, dynamic>{
      'superior': instance.superior,
      'subordinate': instance.subordinate,
    };
