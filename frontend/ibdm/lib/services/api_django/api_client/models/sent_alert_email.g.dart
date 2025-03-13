// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sent_alert_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentAlertEmail _$SentAlertEmailFromJson(Map<String, dynamic> json) =>
    SentAlertEmail(
      id: (json['id'] as num).toInt(),
      alert: AlertEmail.fromJson(json['alert'] as Map<String, dynamic>),
      atValue: (json['at_value'] as num).toDouble(),
      alertType: AlertTypeEnum.fromJson(json['alert_type'] as String),
    );

Map<String, dynamic> _$SentAlertEmailToJson(SentAlertEmail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alert': instance.alert,
      'at_value': instance.atValue,
      'alert_type': _$AlertTypeEnumEnumMap[instance.alertType]!,
    };

const _$AlertTypeEnumEnumMap = {
  AlertTypeEnum.danger: 'danger',
  AlertTypeEnum.warning: 'warning',
  AlertTypeEnum.$unknown: r'$unknown',
};
