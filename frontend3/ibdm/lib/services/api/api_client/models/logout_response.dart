// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'logout_response.g.dart';

@JsonSerializable()
class LogoutResponse {
  const LogoutResponse({
    required this.message,
  });
  
  factory LogoutResponse.fromJson(Map<String, Object?> json) => _$LogoutResponseFromJson(json);
  
  final String message;

  Map<String, Object?> toJson() => _$LogoutResponseToJson(this);
}
