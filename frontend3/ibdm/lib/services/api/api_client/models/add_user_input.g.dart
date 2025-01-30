// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_user_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserInput _$AddUserInputFromJson(Map<String, dynamic> json) => AddUserInput(
      email: json['email'] as String,
      password: json['password'] as String,
      role: Role.fromJson(json['role'] as String),
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      superiorId: json['superior_id'] as String?,
    );

Map<String, dynamic> _$AddUserInputToJson(AddUserInput instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'role': _$RoleEnumMap[instance.role]!,
      'phone_number': instance.phoneNumber,
      'superior_id': instance.superiorId,
    };

const _$RoleEnumMap = {
  Role.adminSystem: 'ADMIN_SYSTEM',
  Role.admin: 'ADMIN',
  Role.supervisor: 'SUPERVISOR',
  Role.operateur: 'OPERATEUR',
  Role.$unknown: r'$unknown',
};
