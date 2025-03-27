// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_role_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchedRoleRequest _$PatchedRoleRequestFromJson(Map<String, dynamic> json) =>
    PatchedRoleRequest(
      groupId: (json['group_id'] as num).toInt(),
      managedRoles: (json['managed_roles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$PatchedRoleRequestToJson(PatchedRoleRequest instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'managed_roles': instance.managedRoles,
      'color': instance.color,
    };
