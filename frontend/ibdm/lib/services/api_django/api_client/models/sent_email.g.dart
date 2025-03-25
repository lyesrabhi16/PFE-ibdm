// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentEmail _$SentEmailFromJson(Map<String, dynamic> json) => SentEmail(
      id: (json['id'] as num).toInt(),
      tempsEnvoi: DateTime.parse(json['temps_envoi'] as String),
      receptionist: json['receptionist'] as String,
      schedule: json['schedule'] == null
          ? null
          : EmailSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      alert: json['alert'] == null
          ? null
          : SentAlertEmail.fromJson(json['alert'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SentEmailToJson(SentEmail instance) => <String, dynamic>{
      'id': instance.id,
      'temps_envoi': instance.tempsEnvoi.toIso8601String(),
      'receptionist': instance.receptionist,
      'schedule': instance.schedule,
      'alert': instance.alert,
    };
