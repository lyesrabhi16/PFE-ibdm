// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'delete_api_users_response.g.dart';

@JsonSerializable()
class DeleteApiUsersResponse {
  const DeleteApiUsersResponse({
    required this.message,
  });
  
  factory DeleteApiUsersResponse.fromJson(Map<String, Object?> json) => _$DeleteApiUsersResponseFromJson(json);
  
  final String message;

  Map<String, Object?> toJson() => _$DeleteApiUsersResponseToJson(this);
}
