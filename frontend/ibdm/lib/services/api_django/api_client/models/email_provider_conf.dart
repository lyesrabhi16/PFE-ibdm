// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_provider_conf.g.dart';

@JsonSerializable()
class EmailProviderConf {
  const EmailProviderConf({
    required this.host,
    required this.port,
    required this.useTls,
    required this.user,
    required this.password,
    required this.emailOFSender,
  });
  
  factory EmailProviderConf.fromJson(Map<String, Object?> json) => _$EmailProviderConfFromJson(json);
  
  @JsonKey(name: 'HOST')
  final String host;
  @JsonKey(name: 'PORT')
  final int port;
  @JsonKey(name: 'USE_TLS')
  final bool useTls;
  @JsonKey(name: 'USER')
  final String user;
  @JsonKey(name: 'PASSWORD')
  final String password;
  @JsonKey(name: 'EMAIL_OF_SENDER')
  final String emailOFSender;

  Map<String, Object?> toJson() => _$EmailProviderConfToJson(this);
}
