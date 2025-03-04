// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'possible_monitor_values_alert_emails.g.dart';

@JsonSerializable()
class PossibleMonitorValuesAlertEmails {
  const PossibleMonitorValuesAlertEmails({
    required this.allValues,
    required this.monitoredValues,
    required this.possibleValues,
  });
  
  factory PossibleMonitorValuesAlertEmails.fromJson(Map<String, Object?> json) => _$PossibleMonitorValuesAlertEmailsFromJson(json);
  
  @JsonKey(name: 'all_values')
  final List<String> allValues;
  @JsonKey(name: 'monitored_values')
  final List<String> monitoredValues;
  @JsonKey(name: 'possible_values')
  final List<String> possibleValues;

  Map<String, Object?> toJson() => _$PossibleMonitorValuesAlertEmailsToJson(this);
}
