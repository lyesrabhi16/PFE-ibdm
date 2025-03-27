// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailSchedule _$EmailScheduleFromJson(Map<String, dynamic> json) =>
    EmailSchedule(
      id: (json['id'] as num).toInt(),
      rapport: RapportEnum.fromJson(json['rapport'] as String),
      tempsEnvoi: json['temps_envoi'] as String,
      interval: IntervalEnum.fromJson(json['interval'] as String),
      scheduledUsers: (json['scheduled_users'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scheduledRoles: (json['scheduled_roles'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      intervalManual: (json['interval_manual'] as num?)?.toInt(),
      nextRunTime: json['next_run_time'] == null
          ? null
          : DateTime.parse(json['next_run_time'] as String),
    );

Map<String, dynamic> _$EmailScheduleToJson(EmailSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rapport': _$RapportEnumEnumMap[instance.rapport]!,
      'temps_envoi': instance.tempsEnvoi,
      'interval': _$IntervalEnumEnumMap[instance.interval]!,
      'interval_manual': instance.intervalManual,
      'next_run_time': instance.nextRunTime?.toIso8601String(),
      'scheduled_users': instance.scheduledUsers,
      'scheduled_roles': instance.scheduledRoles,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
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
