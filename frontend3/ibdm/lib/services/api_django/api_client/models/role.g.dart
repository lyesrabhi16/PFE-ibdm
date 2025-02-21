// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      url: json['url'] as String,
      roleId: (json['role_id'] as num).toInt(),
      name: json['name'] as String,
      groupId: (json['group_id'] as num).toInt(),
      group: Group.fromJson(json['group'] as Map<String, dynamic>),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
      managedRoles: (json['managed_roles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'url': instance.url,
      'role_id': instance.roleId,
      'name': instance.name,
      'group_id': instance.groupId,
      'group': instance.group,
      'permissions': instance.permissions,
      'managed_roles': instance.managedRoles,
    };
