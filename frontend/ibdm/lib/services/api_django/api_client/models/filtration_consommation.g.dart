// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtration_consommation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiltrationConsommation _$FiltrationConsommationFromJson(
        Map<String, dynamic> json) =>
    FiltrationConsommation(
      forage: (json['forage'] as num).toDouble(),
      eauBrute: (json['eau_brute'] as num).toDouble(),
      hytec: (json['hytec'] as num).toDouble(),
      osmotec: (json['osmotec'] as num).toDouble(),
      osmosee: (json['osmosee'] as num).toDouble(),
      contreLavage: (json['contre_lavage'] as num).toDouble(),
    );

Map<String, dynamic> _$FiltrationConsommationToJson(
        FiltrationConsommation instance) =>
    <String, dynamic>{
      'forage': instance.forage,
      'eau_brute': instance.eauBrute,
      'hytec': instance.hytec,
      'osmotec': instance.osmotec,
      'osmosee': instance.osmosee,
      'contre_lavage': instance.contreLavage,
    };
