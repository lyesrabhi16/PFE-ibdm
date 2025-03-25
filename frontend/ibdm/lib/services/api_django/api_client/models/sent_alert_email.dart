// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'alert_email.dart';
import 'alert_type_enum.dart';

part 'sent_alert_email.g.dart';

@JsonSerializable()
class SentAlertEmail {
  const SentAlertEmail({
    required this.id,
    required this.alert,
    required this.atValue,
    required this.alertType,
  });
  
  factory SentAlertEmail.fromJson(Map<String, Object?> json) => _$SentAlertEmailFromJson(json);
  
  final int id;
  final AlertEmail alert;
  @JsonKey(name: 'at_value')
  final double atValue;
  @JsonKey(name: 'alert_type')
  final AlertTypeEnum alertType;

  Map<String, Object?> toJson() => _$SentAlertEmailToJson(this);
}
