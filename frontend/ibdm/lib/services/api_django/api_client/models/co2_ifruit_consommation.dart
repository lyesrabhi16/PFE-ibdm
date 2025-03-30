// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'co2_ifruit.dart';

part 'co2_ifruit_consommation.g.dart';

@JsonSerializable()
class Co2IfruitConsommation {
  const Co2IfruitConsommation({
    required this.date,
    required this.fromDate,
    required this.toDate,
    required this.fromValue,
    required this.toValue,
    this.utCo2Vc1,
    this.utCo2Vc2,
    this.utCo2De,
    this.utCo2Ve,
    this.utCo2Pc1,
    this.utCo2Pc2,
    this.utCo2Pn,
    this.utCo2D182,
    this.utCo2D1833,
    this.utCo2Dcan35,
    this.utCo2Dkrv40,
    this.utCo2Dcan2,
    this.utCo2Dcm16,
    this.utCo2V182,
    this.utCo2V1833,
    this.utCo2Vcan35,
    this.utCo2Vkrv40,
    this.utCo2Vcan2,
    this.utCo2Vcm16,
    this.utCo2P182,
    this.utCo2P1833,
    this.utCo2Pcan35,
    this.utCo2Pkrv40,
    this.utCo2Pcan2,
    this.utCo2Pcm16,
    this.utN2Vn2,
    this.utN2Pn2,
    this.utSoude,
  });
  
  factory Co2IfruitConsommation.fromJson(Map<String, Object?> json) => _$Co2IfruitConsommationFromJson(json);
  
  final DateTime date;
  @JsonKey(name: 'from_date')
  final DateTime fromDate;
  @JsonKey(name: 'to_date')
  final DateTime toDate;
  @JsonKey(name: 'from_value')
  final Co2Ifruit fromValue;
  @JsonKey(name: 'to_value')
  final Co2Ifruit toValue;
  @JsonKey(name: 'ut_co2_vc1')
  final double? utCo2Vc1;
  @JsonKey(name: 'ut_co2_vc2')
  final double? utCo2Vc2;
  @JsonKey(name: 'ut_co2_de')
  final double? utCo2De;
  @JsonKey(name: 'ut_co2_ve')
  final double? utCo2Ve;
  @JsonKey(name: 'ut_co2_pc1')
  final double? utCo2Pc1;
  @JsonKey(name: 'ut_co2_pc2')
  final double? utCo2Pc2;
  @JsonKey(name: 'ut_co2_pn')
  final double? utCo2Pn;
  @JsonKey(name: 'ut_co2_d182')
  final double? utCo2D182;
  @JsonKey(name: 'ut_co2_d1833')
  final double? utCo2D1833;
  @JsonKey(name: 'ut_co2_dcan35')
  final double? utCo2Dcan35;
  @JsonKey(name: 'ut_co2_dkrv40')
  final double? utCo2Dkrv40;
  @JsonKey(name: 'ut_co2_dcan2')
  final double? utCo2Dcan2;
  @JsonKey(name: 'ut_co2_dcm16')
  final double? utCo2Dcm16;
  @JsonKey(name: 'ut_co2_v182')
  final double? utCo2V182;
  @JsonKey(name: 'ut_co2_v1833')
  final double? utCo2V1833;
  @JsonKey(name: 'ut_co2_vcan35')
  final double? utCo2Vcan35;
  @JsonKey(name: 'ut_co2_vkrv40')
  final double? utCo2Vkrv40;
  @JsonKey(name: 'ut_co2_vcan2')
  final double? utCo2Vcan2;
  @JsonKey(name: 'ut_co2_vcm16')
  final double? utCo2Vcm16;
  @JsonKey(name: 'ut_co2_p182')
  final double? utCo2P182;
  @JsonKey(name: 'ut_co2_p1833')
  final double? utCo2P1833;
  @JsonKey(name: 'ut_co2_pcan35')
  final double? utCo2Pcan35;
  @JsonKey(name: 'ut_co2_pkrv40')
  final double? utCo2Pkrv40;
  @JsonKey(name: 'ut_co2_pcan2')
  final double? utCo2Pcan2;
  @JsonKey(name: 'ut_co2_pcm16')
  final double? utCo2Pcm16;
  @JsonKey(name: 'ut_n2_vn2')
  final double? utN2Vn2;
  @JsonKey(name: 'ut_n2_pn2')
  final double? utN2Pn2;
  @JsonKey(name: 'ut_soude')
  final double? utSoude;

  Map<String, Object?> toJson() => _$Co2IfruitConsommationToJson(this);
}
