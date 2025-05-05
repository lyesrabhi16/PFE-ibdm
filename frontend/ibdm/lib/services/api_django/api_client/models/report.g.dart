// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      rapport: json['Rapport'] as String,
      date: DateTime.parse(json['Date'] as String),
      colNames:
          (json['col_names'] as List<dynamic>).map((e) => e as String).toList(),
      data: (json['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      interval: json['Interval'] as String?,
      synthese: json['synthese'] as String?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'Rapport': instance.rapport,
      'Date': instance.date.toIso8601String(),
      'Interval': instance.interval,
      'col_names': instance.colNames,
      'data': instance.data,
      'synthese': instance.synthese,
    };
