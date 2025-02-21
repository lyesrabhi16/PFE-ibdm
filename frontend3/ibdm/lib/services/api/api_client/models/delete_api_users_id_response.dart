// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'delete_api_users_id_response.g.dart';

@JsonSerializable()
class DeleteApiUsersIdResponse {
  const DeleteApiUsersIdResponse({
    required this.message,
  });
  
  factory DeleteApiUsersIdResponse.fromJson(Map<String, Object?> json) => _$DeleteApiUsersIdResponseFromJson(json);
  
  final String message;

  Map<String, Object?> toJson() => _$DeleteApiUsersIdResponseToJson(this);
}
