// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'role_request.g.dart';

@JsonSerializable()
class RoleRequest {
  const RoleRequest({
    required this.groupId,
    required this.managedRoles,
    required this.color,
  });
  
  factory RoleRequest.fromJson(Map<String, Object?> json) => _$RoleRequestFromJson(json);
  
  @JsonKey(name: 'group_id')
  final int groupId;
  @JsonKey(name: 'managed_roles')
  final List<String> managedRoles;
  final String color;

  Map<String, Object?> toJson() => _$RoleRequestToJson(this);
}
