// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'subordinate_and_superior_request.g.dart';

@JsonSerializable()
class SubordinateAndSuperiorRequest {
  const SubordinateAndSuperiorRequest({
    required this.superior,
    required this.subordinate,
  });
  
  factory SubordinateAndSuperiorRequest.fromJson(Map<String, Object?> json) => _$SubordinateAndSuperiorRequestFromJson(json);
  
  final int superior;
  final int subordinate;

  Map<String, Object?> toJson() => _$SubordinateAndSuperiorRequestToJson(this);
}
