// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  const LoginResponse({
    required this.message,
    required this.user,
    required this.sid,
  });
  
  factory LoginResponse.fromJson(Map<String, Object?> json) => _$LoginResponseFromJson(json);
  
  final String message;
  final User user;
  final String sid;

  Map<String, Object?> toJson() => _$LoginResponseToJson(this);
}
