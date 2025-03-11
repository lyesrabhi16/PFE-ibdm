// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'success_response.g.dart';

@JsonSerializable()
class SuccessResponse {
  const SuccessResponse({
    required this.status,
    required this.message,
  });
  
  factory SuccessResponse.fromJson(Map<String, Object?> json) => _$SuccessResponseFromJson(json);
  
  final String status;
  final String message;

  Map<String, Object?> toJson() => _$SuccessResponseToJson(this);
}
