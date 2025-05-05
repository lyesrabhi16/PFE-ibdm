// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  const Report({
    required this.rapport,
    required this.date,
    required this.colNames,
    required this.data,
    this.interval,
    this.synthese,
  });
  
  factory Report.fromJson(Map<String, Object?> json) => _$ReportFromJson(json);
  
  @JsonKey(name: 'Rapport')
  final String rapport;
  @JsonKey(name: 'Date')
  final DateTime date;
  @JsonKey(name: 'Interval')
  final String? interval;
  @JsonKey(name: 'col_names')
  final List<String> colNames;
  final List<Map<String, dynamic>> data;
  final String? synthese;

  Map<String, Object?> toJson() => _$ReportToJson(this);
}
