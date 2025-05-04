// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtration_meta_consommation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiltrationMetaConsommation _$FiltrationMetaConsommationFromJson(
        Map<String, dynamic> json) =>
    FiltrationMetaConsommation(
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      consommation: FiltrationConsommation.fromJson(
          json['consommation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FiltrationMetaConsommationToJson(
        FiltrationMetaConsommation instance) =>
    <String, dynamic>{
      'from_date': instance.fromDate.toIso8601String(),
      'to_date': instance.toDate.toIso8601String(),
      'consommation': instance.consommation,
    };
