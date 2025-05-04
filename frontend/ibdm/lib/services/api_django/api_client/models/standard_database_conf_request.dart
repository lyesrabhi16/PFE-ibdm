// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'standard_database_conf_request.g.dart';

@JsonSerializable()
class StandardDatabaseConfRequest {
  const StandardDatabaseConfRequest({
    required this.engine,
    required this.name,
    required this.user,
    required this.password,
    required this.host,
    required this.port,
    required this.options,
  });
  
  factory StandardDatabaseConfRequest.fromJson(Map<String, Object?> json) => _$StandardDatabaseConfRequestFromJson(json);
  
  @JsonKey(name: 'ENGINE')
  final String? engine;
  @JsonKey(name: 'NAME')
  final String? name;
  @JsonKey(name: 'USER')
  final String? user;
  @JsonKey(name: 'PASSWORD')
  final String? password;
  @JsonKey(name: 'HOST')
  final String? host;
  @JsonKey(name: 'PORT')
  final String? port;
  @JsonKey(name: 'OPTIONS')
  final Map<String, dynamic>? options;

  Map<String, Object?> toJson() => _$StandardDatabaseConfRequestToJson(this);
}
