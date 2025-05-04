// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'alert_enum.dart';
import 'monitor_type_enum.dart';

part 'alert_email.g.dart';

@JsonSerializable()
class AlertEmail {
  const AlertEmail({
    required this.id,
    required this.monitoredValue,
    required this.sendToUsers,
    required this.sendToRoles,
    this.monitorType,
    this.dangerPoint,
    this.warningPoint,
    this.dangerReminderInterval,
    this.warningReminderInterval,
    this.customAlertMessage,
    this.enabled,
  });
  
  factory AlertEmail.fromJson(Map<String, Object?> json) => _$AlertEmailFromJson(json);
  
  final int id;
  @JsonKey(name: 'monitored_value')
  final AlertEnum monitoredValue;
  @JsonKey(name: 'monitor_type')
  final MonitorTypeEnum? monitorType;
  @JsonKey(name: 'danger_point')
  final double? dangerPoint;
  @JsonKey(name: 'warning_point')
  final double? warningPoint;
  @JsonKey(name: 'danger_reminder_interval')
  final int? dangerReminderInterval;
  @JsonKey(name: 'warning_reminder_interval')
  final int? warningReminderInterval;
  @JsonKey(name: 'custom_alert_message')
  final String? customAlertMessage;
  @JsonKey(name: 'send_to_users')
  final List<String> sendToUsers;
  @JsonKey(name: 'send_to_roles')
  final List<int?> sendToRoles;
  final bool? enabled;

  Map<String, Object?> toJson() => _$AlertEmailToJson(this);
}
