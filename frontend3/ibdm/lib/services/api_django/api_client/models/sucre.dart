// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sucre.g.dart';

@JsonSerializable()
class Sucre {
  const Sucre({
    required this.url,
    required this.date,
    this.tS21,
    this.tS22,
    this.tS23,
    this.tS24,
    this.tS25,
    this.aT02,
    this.aT03,
    this.aT04,
    this.aT05,
    this.aT06,
  });
  
  factory Sucre.fromJson(Map<String, Object?> json) => _$SucreFromJson(json);
  
  final String url;
  final DateTime date;
  @JsonKey(name: 't_s21')
  final double? tS21;
  @JsonKey(name: 't_s22')
  final double? tS22;
  @JsonKey(name: 't_s23')
  final double? tS23;
  @JsonKey(name: 't_s24')
  final double? tS24;
  @JsonKey(name: 't_s25')
  final double? tS25;
  @JsonKey(name: 'a_t02')
  final double? aT02;
  @JsonKey(name: 'a_t03')
  final double? aT03;
  @JsonKey(name: 'a_t04')
  final double? aT04;
  @JsonKey(name: 'a_t05')
  final double? aT05;
  @JsonKey(name: 'a_t06')
  final double? aT06;

  Map<String, Object?> toJson() => _$SucreToJson(this);
}
