// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'get_api_users_id_response.g.dart';

@JsonSerializable()
class GetApiUsersIdResponse {
  const GetApiUsersIdResponse({
    required this.user,
  });
  
  factory GetApiUsersIdResponse.fromJson(Map<String, Object?> json) => _$GetApiUsersIdResponseFromJson(json);
  
  final User user;

  Map<String, Object?> toJson() => _$GetApiUsersIdResponseToJson(this);
}
