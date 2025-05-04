// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'standard_database_conf.g.dart';

@JsonSerializable()
class StandardDatabaseConf {
  const StandardDatabaseConf({
    this.engine,
    this.name,
    this.user,
    this.password,
    this.host,
    this.port,
    this.options,
  });
  
  factory StandardDatabaseConf.fromJson(Map<String, Object?> json) => _$StandardDatabaseConfFromJson(json);
  
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

  Map<String, Object?> toJson() => _$StandardDatabaseConfToJson(this);
}
