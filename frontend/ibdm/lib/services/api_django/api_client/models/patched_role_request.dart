// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'patched_role_request.g.dart';

@JsonSerializable()
class PatchedRoleRequest {
  const PatchedRoleRequest({
    required this.groupId,
    required this.managedRoles,
    required this.color,
  });
  
  factory PatchedRoleRequest.fromJson(Map<String, Object?> json) => _$PatchedRoleRequestFromJson(json);
  
  @JsonKey(name: 'group_id')
  final int groupId;
  @JsonKey(name: 'managed_roles')
  final List<String> managedRoles;
  final String color;

  Map<String, Object?> toJson() => _$PatchedRoleRequestToJson(this);
}
