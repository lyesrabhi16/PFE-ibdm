// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'niveau.g.dart';

@JsonSerializable()
class Niveau {
  const Niveau({
    required this.date,
    this.nivF1,
    this.nivF2,
    this.nivUf1,
    this.nivUf2,
    this.nivOs1,
    this.nivOs2,
    this.nivOs3,
    this.nivOs4,
    this.nivOs5,
    this.nivOs6,
    this.nivOs7,
  });
  
  factory Niveau.fromJson(Map<String, Object?> json) => _$NiveauFromJson(json);
  
  final DateTime date;
  @JsonKey(name: 'niv_f1')
  final double? nivF1;
  @JsonKey(name: 'niv_f2')
  final double? nivF2;
  @JsonKey(name: 'niv_uf1')
  final double? nivUf1;
  @JsonKey(name: 'niv_uf2')
  final double? nivUf2;
  @JsonKey(name: 'niv_os1')
  final double? nivOs1;
  @JsonKey(name: 'niv_os2')
  final double? nivOs2;
  @JsonKey(name: 'niv_os3')
  final double? nivOs3;
  @JsonKey(name: 'niv_os4')
  final double? nivOs4;
  @JsonKey(name: 'niv_os5')
  final double? nivOs5;
  @JsonKey(name: 'niv_os6')
  final double? nivOs6;
  @JsonKey(name: 'niv_os7')
  final double? nivOs7;

  Map<String, Object?> toJson() => _$NiveauToJson(this);
}
