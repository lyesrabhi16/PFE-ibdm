// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'filtration_consommation.dart';

part 'filtration_meta_consommation.g.dart';

@JsonSerializable()
class FiltrationMetaConsommation {
  const FiltrationMetaConsommation({
    required this.fromDate,
    required this.toDate,
    required this.consommation,
  });
  
  factory FiltrationMetaConsommation.fromJson(Map<String, Object?> json) => _$FiltrationMetaConsommationFromJson(json);
  
  @JsonKey(name: 'from_date')
  final DateTime fromDate;
  @JsonKey(name: 'to_date')
  final DateTime toDate;
  final FiltrationConsommation consommation;

  Map<String, Object?> toJson() => _$FiltrationMetaConsommationToJson(this);
}
