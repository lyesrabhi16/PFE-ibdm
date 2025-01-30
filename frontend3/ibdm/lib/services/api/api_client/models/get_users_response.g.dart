// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUsersResponse _$GetUsersResponseFromJson(Map<String, dynamic> json) =>
    GetUsersResponse(
      perPage: (json['perPage'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      nbrTotalPages: (json['nbrTotalPages'] as num).toInt(),
      nbrTotalUsers: (json['nbrTotalUsers'] as num).toInt(),
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetUsersResponseToJson(GetUsersResponse instance) =>
    <String, dynamic>{
      'perPage': instance.perPage,
      'currentPage': instance.currentPage,
      'nbrTotalPages': instance.nbrTotalPages,
      'nbrTotalUsers': instance.nbrTotalUsers,
      'users': instance.users,
    };
