// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionRequest _$PermissionRequestFromJson(Map<String, dynamic> json) =>
    PermissionRequest(
      name: json['name'] as String,
      codename: json['codename'] as String,
      contentType: (json['content_type'] as num).toInt(),
    );

Map<String, dynamic> _$PermissionRequestToJson(PermissionRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'codename': instance.codename,
      'content_type': instance.contentType,
    };
