// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co2_multi_meta_consommations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Co2MultiMetaConsommations _$Co2MultiMetaConsommationsFromJson(
        Map<String, dynamic> json) =>
    Co2MultiMetaConsommations(
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      consommations: (json['consommations'] as List<dynamic>)
          .map((e) => Co2IfruitConsommation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Co2MultiMetaConsommationsToJson(
        Co2MultiMetaConsommations instance) =>
    <String, dynamic>{
      'from_date': instance.fromDate.toIso8601String(),
      'to_date': instance.toDate.toIso8601String(),
      'consommations': instance.consommations,
    };
