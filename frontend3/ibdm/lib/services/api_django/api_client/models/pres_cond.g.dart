// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pres_cond.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresCond _$PresCondFromJson(Map<String, dynamic> json) => PresCond(
      date: DateTime.parse(json['date'] as String),
      pUf: (json['p_uf'] as num?)?.toDouble(),
      pUf4: (json['p_uf4'] as num?)?.toDouble(),
      pUf6: (json['p_uf6'] as num?)?.toDouble(),
      pOs1: (json['p_os1'] as num?)?.toDouble(),
      pOs2: (json['p_os2'] as num?)?.toDouble(),
      pOs3: (json['p_os3'] as num?)?.toDouble(),
      pOs4: (json['p_os4'] as num?)?.toDouble(),
      pOs5: (json['p_os5'] as num?)?.toDouble(),
      pOs6: (json['p_os6'] as num?)?.toDouble(),
      pOs7: (json['p_os7'] as num?)?.toDouble(),
      pOs71: (json['p_os71'] as num?)?.toDouble(),
      pOs8: (json['p_os8'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PresCondToJson(PresCond instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'p_uf': instance.pUf,
      'p_uf4': instance.pUf4,
      'p_uf6': instance.pUf6,
      'p_os1': instance.pOs1,
      'p_os2': instance.pOs2,
      'p_os3': instance.pOs3,
      'p_os4': instance.pOs4,
      'p_os5': instance.pOs5,
      'p_os6': instance.pOs6,
      'p_os7': instance.pOs7,
      'p_os71': instance.pOs71,
      'p_os8': instance.pOs8,
    };
