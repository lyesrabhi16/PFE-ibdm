// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'group.dart';
import 'permission.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  const Role({
    required this.roleId,
    required this.name,
    required this.groupId,
    required this.group,
    required this.permissions,
    required this.managedRoles,
    required this.color,
  });
  
  factory Role.fromJson(Map<String, Object?> json) => _$RoleFromJson(json);
  
  @JsonKey(name: 'role_id')
  final int roleId;
  final String name;
  @JsonKey(name: 'group_id')
  final int groupId;
  final Group group;
  final List<Permission> permissions;
  @JsonKey(name: 'managed_roles')
  final List<String> managedRoles;
  final String color;

  Map<String, Object?> toJson() => _$RoleToJson(this);
}
