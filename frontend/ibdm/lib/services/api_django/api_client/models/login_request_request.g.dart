// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestRequest _$LoginRequestRequestFromJson(Map<String, dynamic> json) =>
    LoginRequestRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['remember_me'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginRequestRequestToJson(
        LoginRequestRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'remember_me': instance.rememberMe,
    };
