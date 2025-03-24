// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'patched_permission_request.g.dart';

@JsonSerializable()
class PatchedPermissionRequest {
  const PatchedPermissionRequest({
    required this.name,
    required this.codename,
    required this.contentType,
  });
  
  factory PatchedPermissionRequest.fromJson(Map<String, Object?> json) => _$PatchedPermissionRequestFromJson(json);
  
  final String name;
  final String codename;
  @JsonKey(name: 'content_type')
  final int contentType;

  Map<String, Object?> toJson() => _$PatchedPermissionRequestToJson(this);
}
