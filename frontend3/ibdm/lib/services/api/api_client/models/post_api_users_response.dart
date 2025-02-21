// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'post_api_users_response.g.dart';

@JsonSerializable()
class PostApiUsersResponse {
  const PostApiUsersResponse({
    required this.message,
    required this.user,
  });
  
  factory PostApiUsersResponse.fromJson(Map<String, Object?> json) => _$PostApiUsersResponseFromJson(json);
  
  final String message;
  final User user;

  Map<String, Object?> toJson() => _$PostApiUsersResponseToJson(this);
}
