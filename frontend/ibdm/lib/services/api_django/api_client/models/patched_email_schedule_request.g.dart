// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patched_email_schedule_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchedEmailScheduleRequest _$PatchedEmailScheduleRequestFromJson(
        Map<String, dynamic> json) =>
    PatchedEmailScheduleRequest(
      rapport: RapportEnum.fromJson(json['rapport'] as String),
      tempsEnvoi: json['temps_envoi'] as String,
      interval: IntervalEnum.fromJson(json['interval'] as String),
      scheduledUsers: (json['scheduled_users'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scheduledRoles: (json['scheduled_roles'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      intervalManual: (json['interval_manual'] as num?)?.toInt(),
      nextRunTime: json['next_run_time'] == null
          ? null
          : DateTime.parse(json['next_run_time'] as String),
    );

Map<String, dynamic> _$PatchedEmailScheduleRequestToJson(
        PatchedEmailScheduleRequest instance) =>
    <String, dynamic>{
      'rapport': _$RapportEnumEnumMap[instance.rapport]!,
      'temps_envoi': instance.tempsEnvoi,
      'interval': _$IntervalEnumEnumMap[instance.interval]!,
      'interval_manual': instance.intervalManual,
      'next_run_time': instance.nextRunTime?.toIso8601String(),
      'scheduled_users': instance.scheduledUsers,
      'scheduled_roles': instance.scheduledRoles,
    };

const _$RapportEnumEnumMap = {
  RapportEnum.inventaireSucre: 'inventaire-sucre',
  RapportEnum.utilite: 'utilite',
  RapportEnum.filtration: 'filtration',
  RapportEnum.$unknown: r'$unknown',
};

const _$IntervalEnumEnumMap = {
  IntervalEnum.jour: 'jour',
  IntervalEnum.semaine: 'semaine',
  IntervalEnum.mois: 'mois',
  IntervalEnum.manual: 'manual',
  IntervalEnum.$unknown: r'$unknown',
};
