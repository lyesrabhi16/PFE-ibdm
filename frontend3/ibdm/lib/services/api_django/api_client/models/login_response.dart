// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  const LoginResponse({
    required this.status,
    required this.user,
  });
  
  factory LoginResponse.fromJson(Map<String, Object?> json) => _$LoginResponseFromJson(json);
  
  final String status;
  final User user;

  Map<String, Object?> toJson() => _$LoginResponseToJson(this);
}
