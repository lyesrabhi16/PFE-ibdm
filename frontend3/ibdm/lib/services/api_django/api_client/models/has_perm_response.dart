// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'has_perm_response.g.dart';

@JsonSerializable()
class HasPermResponse {
  const HasPermResponse({
    required this.hasPerm,
  });
  
  factory HasPermResponse.fromJson(Map<String, Object?> json) => _$HasPermResponseFromJson(json);
  
  @JsonKey(name: 'has_perm')
  final bool hasPerm;

  Map<String, Object?> toJson() => _$HasPermResponseToJson(this);
}
