// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtration_multi_meta_consommations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiltrationMultiMetaConsommations _$FiltrationMultiMetaConsommationsFromJson(
        Map<String, dynamic> json) =>
    FiltrationMultiMetaConsommations(
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      consommations: (json['consommations'] as List<dynamic>)
          .map((e) =>
              FiltrationMetaConsommation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FiltrationMultiMetaConsommationsToJson(
        FiltrationMultiMetaConsommations instance) =>
    <String, dynamic>{
      'from_date': instance.fromDate.toIso8601String(),
      'to_date': instance.toDate.toIso8601String(),
      'consommations': instance.consommations,
    };
