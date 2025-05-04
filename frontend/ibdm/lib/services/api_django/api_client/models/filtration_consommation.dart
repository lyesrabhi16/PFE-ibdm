// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'filtration_consommation.g.dart';

@JsonSerializable()
class FiltrationConsommation {
  const FiltrationConsommation({
    required this.forage,
    required this.eauBrute,
    required this.hytec,
    required this.osmotec,
    required this.osmosee,
    required this.contreLavage,
  });
  
  factory FiltrationConsommation.fromJson(Map<String, Object?> json) => _$FiltrationConsommationFromJson(json);
  
  final double forage;
  @JsonKey(name: 'eau_brute')
  final double eauBrute;
  final double hytec;
  final double osmotec;
  final double osmosee;
  @JsonKey(name: 'contre_lavage')
  final double contreLavage;

  Map<String, Object?> toJson() => _$FiltrationConsommationToJson(this);
}
