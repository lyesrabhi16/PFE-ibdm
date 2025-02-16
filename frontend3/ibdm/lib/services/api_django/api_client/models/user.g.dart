// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      url: json['url'] as String,
      userId: (json['user_id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      superiors: (json['superiors'] as List<dynamic>)
          .map((e) =>
              UserSerializerWithSuperiors.fromJson(e as Map<String, dynamic>))
          .toList(),
      subordinates: (json['subordinates'] as List<dynamic>)
          .map((e) => UserSerializerWithSubordinates.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      userPermissions: (json['user_permissions'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'url': instance.url,
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'username': instance.username,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
      'superiors': instance.superiors,
      'subordinates': instance.subordinates,
      'user_permissions': instance.userPermissions,
    };
