// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_provider_conf_request.g.dart';

@JsonSerializable()
class EmailProviderConfRequest {
  const EmailProviderConfRequest({
    required this.host,
    required this.port,
    required this.useTls,
    required this.user,
    required this.password,
    required this.emailOFSender,
  });
  
  factory EmailProviderConfRequest.fromJson(Map<String, Object?> json) => _$EmailProviderConfRequestFromJson(json);
  
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

  Map<String, Object?> toJson() => _$EmailProviderConfRequestToJson(this);
}
