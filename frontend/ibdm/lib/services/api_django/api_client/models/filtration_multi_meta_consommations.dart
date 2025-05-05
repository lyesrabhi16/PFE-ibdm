// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'filtration_meta_consommation.dart';

part 'filtration_multi_meta_consommations.g.dart';

@JsonSerializable()
class FiltrationMultiMetaConsommations {
  const FiltrationMultiMetaConsommations({
    required this.fromDate,
    required this.toDate,
    required this.consommations,
  });
  
  factory FiltrationMultiMetaConsommations.fromJson(Map<String, Object?> json) => _$FiltrationMultiMetaConsommationsFromJson(json);
  
  @JsonKey(name: 'from_date')
  final DateTime fromDate;
  @JsonKey(name: 'to_date')
  final DateTime toDate;
  final List<FiltrationMetaConsommation> consommations;

  Map<String, Object?> toJson() => _$FiltrationMultiMetaConsommationsToJson(this);
}
