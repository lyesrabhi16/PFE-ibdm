// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      role: Role.fromJson(json['role'] as String),
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      superiors: (json['superiors'] as List<dynamic>?)
          ?.map(
              (e) => SuperiorAndSubordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
      subordinates: (json['subordinates'] as List<dynamic>?)
          ?.map(
              (e) => SuperiorAndSubordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _$RoleEnumMap[instance.role]!,
      'phone_number': instance.phoneNumber,
      'superiors': instance.superiors,
      'subordinates': instance.subordinates,
    };

const _$RoleEnumMap = {
  Role.adminSystem: 'ADMIN_SYSTEM',
  Role.admin: 'ADMIN',
  Role.supervisor: 'SUPERVISOR',
  Role.operateur: 'OPERATEUR',
  Role.$unknown: r'$unknown',
};
