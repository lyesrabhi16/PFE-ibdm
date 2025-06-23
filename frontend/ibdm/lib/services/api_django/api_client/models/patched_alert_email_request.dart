// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'alert_enum.dart';
import 'monitor_type_enum.dart';
import 'reminder_interval_unit_enum.dart';

part 'patched_alert_email_request.g.dart';

@JsonSerializable()
class PatchedAlertEmailRequest {
  const PatchedAlertEmailRequest({
    required this.reminderIntervalUnit,
    this.monitoredValue,
    this.monitorType,
    this.dangerPoint,
    this.warningPoint,
    this.dangerReminderInterval,
    this.warningReminderInterval,
    this.customAlertMessage,
    this.sendToUsers,
    this.sendToRoles,
    this.enabled,
  });
  
  factory PatchedAlertEmailRequest.fromJson(Map<String, Object?> json) => _$PatchedAlertEmailRequestFromJson(json);
  
  @JsonKey(name: 'monitored_value')
  final AlertEnum? monitoredValue;
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
  @JsonKey(name: 'reminder_interval_unit')
  final ReminderIntervalUnitEnum reminderIntervalUnit;
  @JsonKey(name: 'custom_alert_message')
  final String? customAlertMessage;
  @JsonKey(name: 'send_to_users')
  final List<String?>? sendToUsers;
  @JsonKey(name: 'send_to_roles')
  final List<int?>? sendToRoles;
  final bool? enabled;

  Map<String, Object?> toJson() => _$PatchedAlertEmailRequestToJson(this);
}
