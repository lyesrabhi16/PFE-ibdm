// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_provider_conf_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailProviderConfRequest _$EmailProviderConfRequestFromJson(
        Map<String, dynamic> json) =>
    EmailProviderConfRequest(
      host: json['HOST'] as String,
      port: (json['PORT'] as num).toInt(),
      useTls: json['USE_TLS'] as bool,
      user: json['USER'] as String,
      password: json['PASSWORD'] as String,
      emailOFSender: json['EMAIL_OF_SENDER'] as String,
    );

Map<String, dynamic> _$EmailProviderConfRequestToJson(
        EmailProviderConfRequest instance) =>
    <String, dynamic>{
      'HOST': instance.host,
      'PORT': instance.port,
      'USE_TLS': instance.useTls,
      'USER': instance.user,
      'PASSWORD': instance.password,
      'EMAIL_OF_SENDER': instance.emailOFSender,
    };
