// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permission _$PermissionFromJson(Map<String, dynamic> json) => Permission(
      url: json['url'] as String,
      permissionId: (json['permission_id'] as num).toInt(),
      name: json['name'] as String,
      codename: json['codename'] as String,
      contentTypeName: json['content_type_name'] as String,
    );

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'url': instance.url,
      'permission_id': instance.permissionId,
      'name': instance.name,
      'codename': instance.codename,
      'content_type_name': instance.contentTypeName,
    };
