// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'pres_cond.g.dart';

@JsonSerializable()
class PresCond {
  const PresCond({
    required this.date,
    this.pUf,
    this.pUf4,
    this.pUf6,
    this.pOs1,
    this.pOs2,
    this.pOs3,
    this.pOs4,
    this.pOs5,
    this.pOs6,
    this.pOs7,
    this.pOs71,
    this.pOs8,
  });
  
  factory PresCond.fromJson(Map<String, Object?> json) => _$PresCondFromJson(json);
  
  final DateTime date;
  @JsonKey(name: 'p_uf')
  final double? pUf;
  @JsonKey(name: 'p_uf4')
  final double? pUf4;
  @JsonKey(name: 'p_uf6')
  final double? pUf6;
  @JsonKey(name: 'p_os1')
  final double? pOs1;
  @JsonKey(name: 'p_os2')
  final double? pOs2;
  @JsonKey(name: 'p_os3')
  final double? pOs3;
  @JsonKey(name: 'p_os4')
  final double? pOs4;
  @JsonKey(name: 'p_os5')
  final double? pOs5;
  @JsonKey(name: 'p_os6')
  final double? pOs6;
  @JsonKey(name: 'p_os7')
  final double? pOs7;
  @JsonKey(name: 'p_os71')
  final double? pOs71;
  @JsonKey(name: 'p_os8')
  final double? pOs8;

  Map<String, Object?> toJson() => _$PresCondToJson(this);
}
