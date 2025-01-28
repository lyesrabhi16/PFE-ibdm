// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetApiUsersResponse _$GetApiUsersResponseFromJson(Map<String, dynamic> json) =>
    GetApiUsersResponse(
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetApiUsersResponseToJson(
        GetApiUsersResponse instance) =>
    <String, dynamic>{
      'users': instance.users,
    };
