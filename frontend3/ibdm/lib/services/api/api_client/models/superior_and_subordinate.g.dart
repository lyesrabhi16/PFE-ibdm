// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superior_and_subordinate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuperiorAndSubordinate _$SuperiorAndSubordinateFromJson(
        Map<String, dynamic> json) =>
    SuperiorAndSubordinate(
      id: json['id'] as String,
      superiorId: json['superior_id'] as String,
      subordinateId: json['subordinate_id'] as String,
      subordinate: json['subordinate'] == null
          ? null
          : User.fromJson(json['subordinate'] as Map<String, dynamic>),
      superior: json['superior'] == null
          ? null
          : User.fromJson(json['superior'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SuperiorAndSubordinateToJson(
        SuperiorAndSubordinate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'superior_id': instance.superiorId,
      'subordinate_id': instance.subordinateId,
      'subordinate': instance.subordinate,
      'superior': instance.superior,
    };
