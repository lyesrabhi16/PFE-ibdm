// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      url: json['url'] as String,
      groupId: (json['group_id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'url': instance.url,
      'group_id': instance.groupId,
      'name': instance.name,
    };
