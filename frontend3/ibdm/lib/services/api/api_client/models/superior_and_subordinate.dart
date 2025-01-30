// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'superior_and_subordinate.g.dart';

@JsonSerializable()
class SuperiorAndSubordinate {
  const SuperiorAndSubordinate({
    required this.id,
    required this.superiorId,
    required this.subordinateId,
    this.subordinate,
    this.superior,
  });
  
  factory SuperiorAndSubordinate.fromJson(Map<String, Object?> json) => _$SuperiorAndSubordinateFromJson(json);
  
  final String id;
  @JsonKey(name: 'superior_id')
  final String superiorId;
  @JsonKey(name: 'subordinate_id')
  final String subordinateId;
  final dynamic subordinate;
  final dynamic superior;

  Map<String, Object?> toJson() => _$SuperiorAndSubordinateToJson(this);
}
