// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'utilite.g.dart';

@JsonSerializable()
class Utilite {
  const Utilite({
    required this.date,
    this.utKrP7,
    this.utKrPn2,
    this.utKrP40,
    this.utKrPv,
    this.utKrPg,
    this.utKrTt,
    this.utKrTc,
    this.utSidP7,
    this.utSidPn2,
    this.utSidP40,
    this.utSidPv,
    this.utSidPg,
    this.utSidTt,
    this.utSidTc,
  });
  
  factory Utilite.fromJson(Map<String, Object?> json) => _$UtiliteFromJson(json);
  
  final DateTime date;
  @JsonKey(name: 'ut_kr_p7')
  final double? utKrP7;
  @JsonKey(name: 'ut_kr_pn2')
  final double? utKrPn2;
  @JsonKey(name: 'ut_kr_p40')
  final double? utKrP40;
  @JsonKey(name: 'ut_kr_pv')
  final double? utKrPv;
  @JsonKey(name: 'ut_kr_pg')
  final double? utKrPg;
  @JsonKey(name: 'ut_kr_tt')
  final double? utKrTt;
  @JsonKey(name: 'ut_kr_tc')
  final double? utKrTc;
  @JsonKey(name: 'ut_sid_p7')
  final double? utSidP7;
  @JsonKey(name: 'ut_sid_pn2')
  final double? utSidPn2;
  @JsonKey(name: 'ut_sid_p40')
  final double? utSidP40;
  @JsonKey(name: 'ut_sid_pv')
  final double? utSidPv;
  @JsonKey(name: 'ut_sid_pg')
  final double? utSidPg;
  @JsonKey(name: 'ut_sid_tt')
  final double? utSidTt;
  @JsonKey(name: 'ut_sid_tc')
  final double? utSidTc;

  Map<String, Object?> toJson() => _$UtiliteToJson(this);
}
