// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'debit.g.dart';

@JsonSerializable()
class Debit {
  const Debit({
    required this.date,
    this.dF1,
    this.dF2,
    this.dUf1,
    this.dUf2,
    this.dUf3,
    this.dUf4,
    this.dUf5,
    this.dUf6,
    this.dOs1,
    this.dOs2,
    this.dOs3,
    this.dOs4,
    this.dOs5,
    this.dOs6,
    this.dOs7,
    this.dOs8,
    this.dOs9,
  });
  
  factory Debit.fromJson(Map<String, Object?> json) => _$DebitFromJson(json);
  
  final DateTime date;
  @JsonKey(name: 'd_f1')
  final double? dF1;
  @JsonKey(name: 'd_f2')
  final double? dF2;
  @JsonKey(name: 'd_uf1')
  final double? dUf1;
  @JsonKey(name: 'd_uf2')
  final double? dUf2;
  @JsonKey(name: 'd_uf3')
  final double? dUf3;
  @JsonKey(name: 'd_uf4')
  final double? dUf4;
  @JsonKey(name: 'd_uf5')
  final double? dUf5;
  @JsonKey(name: 'd_uf6')
  final double? dUf6;
  @JsonKey(name: 'd_os1')
  final double? dOs1;
  @JsonKey(name: 'd_os2')
  final double? dOs2;
  @JsonKey(name: 'd_os3')
  final double? dOs3;
  @JsonKey(name: 'd_os4')
  final double? dOs4;
  @JsonKey(name: 'd_os5')
  final double? dOs5;
  @JsonKey(name: 'd_os6')
  final double? dOs6;
  @JsonKey(name: 'd_os7')
  final double? dOs7;
  @JsonKey(name: 'd_os8')
  final double? dOs8;
  @JsonKey(name: 'd_os9')
  final double? dOs9;

  Map<String, Object?> toJson() => _$DebitToJson(this);
}
