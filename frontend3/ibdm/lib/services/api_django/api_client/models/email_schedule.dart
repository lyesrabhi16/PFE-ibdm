// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'interval_enum.dart';
import 'rapport_enum.dart';

part 'email_schedule.g.dart';

@JsonSerializable()
class EmailSchedule {
  const EmailSchedule({
    required this.url,
    required this.rapport,
    required this.tempsEnvoi,
    required this.interval,
    required this.scheduledUsers,
    required this.scheduledRoles,
    required this.createdAt,
    required this.updatedAt,
    this.intervalManual,
    this.nextRunTime,
  });
  
  factory EmailSchedule.fromJson(Map<String, Object?> json) => _$EmailScheduleFromJson(json);
  
  final String url;
  final RapportEnum rapport;
  @JsonKey(name: 'temps_envoi')
  final String tempsEnvoi;
  final IntervalEnum interval;
  @JsonKey(name: 'interval_manual')
  final int? intervalManual;
  @JsonKey(name: 'next_run_time')
  final DateTime? nextRunTime;
  @JsonKey(name: 'scheduled_users')
  final List<String> scheduledUsers;
  @JsonKey(name: 'scheduled_roles')
  final List<int> scheduledRoles;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$EmailScheduleToJson(this);
}
