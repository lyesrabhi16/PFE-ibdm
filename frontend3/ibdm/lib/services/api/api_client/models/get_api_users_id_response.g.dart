// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_users_id_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetApiUsersIdResponse _$GetApiUsersIdResponseFromJson(
        Map<String, dynamic> json) =>
    GetApiUsersIdResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetApiUsersIdResponseToJson(
        GetApiUsersIdResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
    };
