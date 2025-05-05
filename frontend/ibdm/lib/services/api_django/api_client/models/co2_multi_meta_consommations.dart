// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'co2_ifruit_consommation.dart';

part 'co2_multi_meta_consommations.g.dart';

@JsonSerializable()
class Co2MultiMetaConsommations {
  const Co2MultiMetaConsommations({
    required this.fromDate,
    required this.toDate,
    required this.consommations,
  });
  
  factory Co2MultiMetaConsommations.fromJson(Map<String, Object?> json) => _$Co2MultiMetaConsommationsFromJson(json);
  
  @JsonKey(name: 'from_date')
  final DateTime fromDate;
  @JsonKey(name: 'to_date')
  final DateTime toDate;
  final List<Co2IfruitConsommation> consommations;

  Map<String, Object?> toJson() => _$Co2MultiMetaConsommationsToJson(this);
}
