// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'patched_subordinate_and_superior_request.g.dart';

@JsonSerializable()
class PatchedSubordinateAndSuperiorRequest {
  const PatchedSubordinateAndSuperiorRequest({
    required this.superior,
    required this.subordinate,
  });
  
  factory PatchedSubordinateAndSuperiorRequest.fromJson(Map<String, Object?> json) => _$PatchedSubordinateAndSuperiorRequestFromJson(json);
  
  final int superior;
  final int subordinate;

  Map<String, Object?> toJson() => _$PatchedSubordinateAndSuperiorRequestToJson(this);
}
