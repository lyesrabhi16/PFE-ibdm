// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Debit _$DebitFromJson(Map<String, dynamic> json) => Debit(
      date: DateTime.parse(json['date'] as String),
      dF1: (json['d_f1'] as num?)?.toDouble(),
      dF2: (json['d_f2'] as num?)?.toDouble(),
      dUf1: (json['d_uf1'] as num?)?.toDouble(),
      dUf2: (json['d_uf2'] as num?)?.toDouble(),
      dUf3: (json['d_uf3'] as num?)?.toDouble(),
      dUf4: (json['d_uf4'] as num?)?.toDouble(),
      dUf5: (json['d_uf5'] as num?)?.toDouble(),
      dUf6: (json['d_uf6'] as num?)?.toDouble(),
      dOs1: (json['d_os1'] as num?)?.toDouble(),
      dOs2: (json['d_os2'] as num?)?.toDouble(),
      dOs3: (json['d_os3'] as num?)?.toDouble(),
      dOs4: (json['d_os4'] as num?)?.toDouble(),
      dOs5: (json['d_os5'] as num?)?.toDouble(),
      dOs6: (json['d_os6'] as num?)?.toDouble(),
      dOs7: (json['d_os7'] as num?)?.toDouble(),
      dOs8: (json['d_os8'] as num?)?.toDouble(),
      dOs9: (json['d_os9'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DebitToJson(Debit instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'd_f1': instance.dF1,
      'd_f2': instance.dF2,
      'd_uf1': instance.dUf1,
      'd_uf2': instance.dUf2,
      'd_uf3': instance.dUf3,
      'd_uf4': instance.dUf4,
      'd_uf5': instance.dUf5,
      'd_uf6': instance.dUf6,
      'd_os1': instance.dOs1,
      'd_os2': instance.dOs2,
      'd_os3': instance.dOs3,
      'd_os4': instance.dOs4,
      'd_os5': instance.dOs5,
      'd_os6': instance.dOs6,
      'd_os7': instance.dOs7,
      'd_os8': instance.dOs8,
      'd_os9': instance.dOs9,
    };
