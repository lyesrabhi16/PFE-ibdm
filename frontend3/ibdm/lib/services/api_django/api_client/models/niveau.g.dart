// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'niveau.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Niveau _$NiveauFromJson(Map<String, dynamic> json) => Niveau(
      date: DateTime.parse(json['date'] as String),
      nivF1: (json['niv_f1'] as num?)?.toDouble(),
      nivF2: (json['niv_f2'] as num?)?.toDouble(),
      nivUf1: (json['niv_uf1'] as num?)?.toDouble(),
      nivUf2: (json['niv_uf2'] as num?)?.toDouble(),
      nivOs1: (json['niv_os1'] as num?)?.toDouble(),
      nivOs2: (json['niv_os2'] as num?)?.toDouble(),
      nivOs3: (json['niv_os3'] as num?)?.toDouble(),
      nivOs4: (json['niv_os4'] as num?)?.toDouble(),
      nivOs5: (json['niv_os5'] as num?)?.toDouble(),
      nivOs6: (json['niv_os6'] as num?)?.toDouble(),
      nivOs7: (json['niv_os7'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NiveauToJson(Niveau instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'niv_f1': instance.nivF1,
      'niv_f2': instance.nivF2,
      'niv_uf1': instance.nivUf1,
      'niv_uf2': instance.nivUf2,
      'niv_os1': instance.nivOs1,
      'niv_os2': instance.nivOs2,
      'niv_os3': instance.nivOs3,
      'niv_os4': instance.nivOs4,
      'niv_os5': instance.nivOs5,
      'niv_os6': instance.nivOs6,
      'niv_os7': instance.nivOs7,
    };
