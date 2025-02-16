// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_serializer_with_subordinates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSerializerWithSubordinates _$UserSerializerWithSubordinatesFromJson(
        Map<String, dynamic> json) =>
    UserSerializerWithSubordinates(
      url: json['url'] as String,
      userId: (json['user_id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      subordinates: (json['subordinates'] as List<dynamic>)
          .map((e) => UserSerializerWithSubordinates.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserSerializerWithSubordinatesToJson(
        UserSerializerWithSubordinates instance) =>
    <String, dynamic>{
      'url': instance.url,
      'user_id': instance.userId,
      'email': instance.email,
      'username': instance.username,
      'subordinates': instance.subordinates,
    };
