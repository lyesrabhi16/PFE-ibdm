// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_perms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPerms _$UserPermsFromJson(Map<String, dynamic> json) => UserPerms(
      perms: (json['perms'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserPermsToJson(UserPerms instance) => <String, dynamic>{
      'perms': instance.perms,
    };
