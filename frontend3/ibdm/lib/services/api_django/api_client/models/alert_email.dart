// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'alert_enum.dart';

part 'alert_email.g.dart';

@JsonSerializable()
class AlertEmail {
  const AlertEmail({
    required this.id,
    required this.sendToUsers,
    required this.monitoredValue,
    required this.dangerPoint,
    required this.warningPoint,
    required this.dangerReminderInterval,
    required this.warningReminderInterval,
    required this.enabled,
    required this.sendToRoles,
    this.customAlertMessage,
  });
  
  factory AlertEmail.fromJson(Map<String, Object?> json) => _$AlertEmailFromJson(json);
  
  final int id;
  @JsonKey(name: 'send_to_users')
  final List<String> sendToUsers;
  @JsonKey(name: 'monitored_value')
  final AlertEnum monitoredValue;
  @JsonKey(name: 'danger_point')
  final int dangerPoint;
  @JsonKey(name: 'warning_point')
  final int warningPoint;
  @JsonKey(name: 'danger_reminder_interval')
  final int dangerReminderInterval;
  @JsonKey(name: 'warning_reminder_interval')
  final int warningReminderInterval;
  @JsonKey(name: 'custom_alert_message')
  final String? customAlertMessage;
  final bool enabled;
  @JsonKey(name: 'send_to_roles')
  final List<int?> sendToRoles;

  Map<String, Object?> toJson() => _$AlertEmailToJson(this);
}
