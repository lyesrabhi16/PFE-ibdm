// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standard_database_conf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandardDatabaseConf _$StandardDatabaseConfFromJson(
        Map<String, dynamic> json) =>
    StandardDatabaseConf(
      engine: json['ENGINE'] as String?,
      name: json['NAME'] as String?,
      user: json['USER'] as String?,
      password: json['PASSWORD'] as String?,
      host: json['HOST'] as String?,
      port: json['PORT'] as String?,
      options: json['OPTIONS'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StandardDatabaseConfToJson(
        StandardDatabaseConf instance) =>
    <String, dynamic>{
      'ENGINE': instance.engine,
      'NAME': instance.name,
      'USER': instance.user,
      'PASSWORD': instance.password,
      'HOST': instance.host,
      'PORT': instance.port,
      'OPTIONS': instance.options,
    };
