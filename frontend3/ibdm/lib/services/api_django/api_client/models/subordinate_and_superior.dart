// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'subordinate_and_superior.g.dart';

@JsonSerializable()
class SubordinateAndSuperior {
  const SubordinateAndSuperior({
    required this.superior,
    required this.subordinate,
  });
  
  factory SubordinateAndSuperior.fromJson(Map<String, Object?> json) => _$SubordinateAndSuperiorFromJson(json);
  
  final int superior;
  final int subordinate;

  Map<String, Object?> toJson() => _$SubordinateAndSuperiorToJson(this);
}
