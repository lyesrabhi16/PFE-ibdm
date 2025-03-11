// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'interval_enum.dart';
import 'rapport_enum.dart';

part 'patched_email_schedule_request.g.dart';

@JsonSerializable()
class PatchedEmailScheduleRequest {
  const PatchedEmailScheduleRequest({
    required this.rapport,
    required this.tempsEnvoi,
    required this.interval,
    required this.scheduledUsers,
    required this.scheduledRoles,
    this.intervalManual,
    this.nextRunTime,
  });
  
  factory PatchedEmailScheduleRequest.fromJson(Map<String, Object?> json) => _$PatchedEmailScheduleRequestFromJson(json);
  
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

  Map<String, Object?> toJson() => _$PatchedEmailScheduleRequestToJson(this);
}
