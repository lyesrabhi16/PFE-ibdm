// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'get_api_users_response.g.dart';

@JsonSerializable()
class GetApiUsersResponse {
  const GetApiUsersResponse({
    required this.users,
  });
  
  factory GetApiUsersResponse.fromJson(Map<String, Object?> json) => _$GetApiUsersResponseFromJson(json);
  
  final List<User> users;

  Map<String, Object?> toJson() => _$GetApiUsersResponseToJson(this);
}
