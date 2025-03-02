// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sucre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sucre _$SucreFromJson(Map<String, dynamic> json) => Sucre(
      date: DateTime.parse(json['date'] as String),
      tS21: (json['t_s21'] as num?)?.toDouble(),
      tS22: (json['t_s22'] as num?)?.toDouble(),
      tS23: (json['t_s23'] as num?)?.toDouble(),
      tS24: (json['t_s24'] as num?)?.toDouble(),
      tS25: (json['t_s25'] as num?)?.toDouble(),
      aT02: (json['a_t02'] as num?)?.toDouble(),
      aT03: (json['a_t03'] as num?)?.toDouble(),
      aT04: (json['a_t04'] as num?)?.toDouble(),
      aT05: (json['a_t05'] as num?)?.toDouble(),
      aT06: (json['a_t06'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SucreToJson(Sucre instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      't_s21': instance.tS21,
      't_s22': instance.tS22,
      't_s23': instance.tS23,
      't_s24': instance.tS24,
      't_s25': instance.tS25,
      'a_t02': instance.aT02,
      'a_t03': instance.aT03,
      'a_t04': instance.aT04,
      'a_t05': instance.aT05,
      'a_t06': instance.aT06,
    };
