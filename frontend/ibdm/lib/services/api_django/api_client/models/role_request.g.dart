// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleRequest _$RoleRequestFromJson(Map<String, dynamic> json) => RoleRequest(
      groupId: (json['group_id'] as num).toInt(),
      managedRoles: (json['managed_roles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$RoleRequestToJson(RoleRequest instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'managed_roles': instance.managedRoles,
      'color': instance.color,
    };
