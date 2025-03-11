// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'permission.g.dart';

@JsonSerializable()
class Permission {
  const Permission({
    required this.permissionId,
    required this.name,
    required this.codename,
    required this.contentTypeName,
  });
  
  factory Permission.fromJson(Map<String, Object?> json) => _$PermissionFromJson(json);
  
  @JsonKey(name: 'permission_id')
  final int permissionId;
  final String name;
  final String codename;
  @JsonKey(name: 'content_type_name')
  final String contentTypeName;

  Map<String, Object?> toJson() => _$PermissionToJson(this);
}
