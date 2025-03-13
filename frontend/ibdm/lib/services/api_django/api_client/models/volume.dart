// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'volume.g.dart';

@JsonSerializable()
class Volume {
  const Volume({
    required this.date,
    this.volFor,
    this.volUf1,
    this.volUf2,
    this.volUf3,
    this.volUf4,
    this.volUf5,
    this.volUf6,
    this.volOs1,
    this.volOs2,
    this.volOs3,
    this.volOs4,
    this.volOs5,
    this.volOs6,
    this.volOs7,
    this.volOs8,
    this.volOs9,
  });
  
  factory Volume.fromJson(Map<String, Object?> json) => _$VolumeFromJson(json);
  
  final DateTime date;
  @JsonKey(name: 'vol_for')
  final double? volFor;
  @JsonKey(name: 'vol_uf1')
  final double? volUf1;
  @JsonKey(name: 'vol_uf2')
  final double? volUf2;
  @JsonKey(name: 'vol_uf3')
  final double? volUf3;
  @JsonKey(name: 'vol_uf4')
  final double? volUf4;
  @JsonKey(name: 'vol_uf5')
  final double? volUf5;
  @JsonKey(name: 'vol_uf6')
  final double? volUf6;
  @JsonKey(name: 'vol_os1')
  final double? volOs1;
  @JsonKey(name: 'vol_os2')
  final double? volOs2;
  @JsonKey(name: 'vol_os3')
  final double? volOs3;
  @JsonKey(name: 'vol_os4')
  final double? volOs4;
  @JsonKey(name: 'vol_os5')
  final double? volOs5;
  @JsonKey(name: 'vol_os6')
  final double? volOs6;
  @JsonKey(name: 'vol_os7')
  final double? volOs7;
  @JsonKey(name: 'vol_os8')
  final double? volOs8;
  @JsonKey(name: 'vol_os9')
  final double? volOs9;

  Map<String, Object?> toJson() => _$VolumeToJson(this);
}
