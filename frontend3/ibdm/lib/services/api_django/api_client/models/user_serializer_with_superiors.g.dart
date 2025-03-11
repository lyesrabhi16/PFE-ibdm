// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_serializer_with_superiors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSerializerWithSuperiors _$UserSerializerWithSuperiorsFromJson(
        Map<String, dynamic> json) =>
    UserSerializerWithSuperiors(
      userId: (json['user_id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      superiors: (json['superiors'] as List<dynamic>)
          .map((e) =>
              UserSerializerWithSuperiors.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserSerializerWithSuperiorsToJson(
        UserSerializerWithSuperiors instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'username': instance.username,
      'superiors': instance.superiors,
    };
