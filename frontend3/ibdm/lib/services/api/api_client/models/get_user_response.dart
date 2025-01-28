// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'get_user_response.g.dart';

@JsonSerializable()
class GetUserResponse {
  const GetUserResponse({
    required this.message,
    required this.user,
  });
  
  factory GetUserResponse.fromJson(Map<String, Object?> json) => _$GetUserResponseFromJson(json);
  
  final String message;
  final User user;

  Map<String, Object?> toJson() => _$GetUserResponseToJson(this);
}
