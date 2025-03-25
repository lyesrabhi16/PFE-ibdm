// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'possible_monitor_values_alert_emails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PossibleMonitorValuesAlertEmails _$PossibleMonitorValuesAlertEmailsFromJson(
        Map<String, dynamic> json) =>
    PossibleMonitorValuesAlertEmails(
      allValues: (json['all_values'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      monitoredValues: (json['monitored_values'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      possibleValues: (json['possible_values'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PossibleMonitorValuesAlertEmailsToJson(
        PossibleMonitorValuesAlertEmails instance) =>
    <String, dynamic>{
      'all_values': instance.allValues,
      'monitored_values': instance.monitoredValues,
      'possible_values': instance.possibleValues,
    };
