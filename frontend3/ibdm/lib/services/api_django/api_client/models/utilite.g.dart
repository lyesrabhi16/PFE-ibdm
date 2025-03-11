// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Utilite _$UtiliteFromJson(Map<String, dynamic> json) => Utilite(
      date: DateTime.parse(json['date'] as String),
      utKrP7: (json['ut_kr_p7'] as num?)?.toDouble(),
      utKrPn2: (json['ut_kr_pn2'] as num?)?.toDouble(),
      utKrP40: (json['ut_kr_p40'] as num?)?.toDouble(),
      utKrPv: (json['ut_kr_pv'] as num?)?.toDouble(),
      utKrPg: (json['ut_kr_pg'] as num?)?.toDouble(),
      utKrTt: (json['ut_kr_tt'] as num?)?.toDouble(),
      utKrTc: (json['ut_kr_tc'] as num?)?.toDouble(),
      utSidP7: (json['ut_sid_p7'] as num?)?.toDouble(),
      utSidPn2: (json['ut_sid_pn2'] as num?)?.toDouble(),
      utSidP40: (json['ut_sid_p40'] as num?)?.toDouble(),
      utSidPv: (json['ut_sid_pv'] as num?)?.toDouble(),
      utSidPg: (json['ut_sid_pg'] as num?)?.toDouble(),
      utSidTt: (json['ut_sid_tt'] as num?)?.toDouble(),
      utSidTc: (json['ut_sid_tc'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UtiliteToJson(Utilite instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'ut_kr_p7': instance.utKrP7,
      'ut_kr_pn2': instance.utKrPn2,
      'ut_kr_p40': instance.utKrP40,
      'ut_kr_pv': instance.utKrPv,
      'ut_kr_pg': instance.utKrPg,
      'ut_kr_tt': instance.utKrTt,
      'ut_kr_tc': instance.utKrTc,
      'ut_sid_p7': instance.utSidP7,
      'ut_sid_pn2': instance.utSidPn2,
      'ut_sid_p40': instance.utSidP40,
      'ut_sid_pv': instance.utSidPv,
      'ut_sid_pg': instance.utSidPg,
      'ut_sid_tt': instance.utSidTt,
      'ut_sid_tc': instance.utSidTc,
    };
