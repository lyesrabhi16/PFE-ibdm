// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'permission_request.g.dart';

@JsonSerializable()
class PermissionRequest {
  const PermissionRequest({
    required this.name,
    required this.codename,
    required this.contentType,
  });
  
  factory PermissionRequest.fromJson(Map<String, Object?> json) => _$PermissionRequestFromJson(json);
  
  final String name;
  final String codename;
  @JsonKey(name: 'content_type')
  final int contentType;

  Map<String, Object?> toJson() => _$PermissionRequestToJson(this);
}
