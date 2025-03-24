// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'login_request_request.g.dart';

@JsonSerializable()
class LoginRequestRequest {
  const LoginRequestRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  factory LoginRequestRequest.fromJson(Map<String, Object?> json) => _$LoginRequestRequestFromJson(json);
  
  final String email;
  final String password;
  @JsonKey(name: 'remember_me')
  final bool rememberMe;

  Map<String, Object?> toJson() => _$LoginRequestRequestToJson(this);
}
