// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentEmail _$SentEmailFromJson(Map<String, dynamic> json) => SentEmail(
      url: json['url'] as String,
      id: (json['id'] as num).toInt(),
      tempsEnvoi: DateTime.parse(json['temps_envoi'] as String),
      receptionist: json['receptionist'] as String,
      schedule: (json['schedule'] as num).toInt(),
    );

Map<String, dynamic> _$SentEmailToJson(SentEmail instance) => <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'temps_envoi': instance.tempsEnvoi.toIso8601String(),
      'receptionist': instance.receptionist,
      'schedule': instance.schedule,
    };
