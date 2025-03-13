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
      pOs9: (json['p_os9'] as num?)?.toDouble(),
      pOse1: (json['p_ose1'] as num?)?.toDouble(),
      pOse2: (json['p_ose2'] as num?)?.toDouble(),
      pConc: (json['p_conc'] as num?)?.toDouble(),
      cUf: (json['c_uf'] as num?)?.toDouble(),
      cOs1: (json['c_os1'] as num?)?.toDouble(),
      cOs2: (json['c_os2'] as num?)?.toDouble(),
      cOs3: (json['c_os3'] as num?)?.toDouble(),
      cOs4: (json['c_os4'] as num?)?.toDouble(),
      cOs5: (json['c_os5'] as num?)?.toDouble(),
      cOs6: (json['c_os6'] as num?)?.toDouble(),
      cOs7: (json['c_os7'] as num?)?.toDouble(),
      cOs8: (json['c_os8'] as num?)?.toDouble(),
      cOs9: (json['c_os9'] as num?)?.toDouble(),
      cOse: (json['c_ose'] as num?)?.toDouble(),
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
      'p_os9': instance.pOs9,
      'p_ose1': instance.pOse1,
      'p_ose2': instance.pOse2,
      'p_conc': instance.pConc,
      'c_uf': instance.cUf,
      'c_os1': instance.cOs1,
      'c_os2': instance.cOs2,
      'c_os3': instance.cOs3,
      'c_os4': instance.cOs4,
      'c_os5': instance.cOs5,
      'c_os6': instance.cOs6,
      'c_os7': instance.cOs7,
      'c_os8': instance.cOs8,
      'c_os9': instance.cOs9,
      'c_ose': instance.cOse,
    };
