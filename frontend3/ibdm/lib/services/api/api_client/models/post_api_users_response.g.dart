// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiUsersResponse _$PostApiUsersResponseFromJson(
        Map<String, dynamic> json) =>
    PostApiUsersResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostApiUsersResponseToJson(
        PostApiUsersResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };
