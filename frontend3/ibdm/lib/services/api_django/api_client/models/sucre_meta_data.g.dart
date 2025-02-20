// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sucre_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SucreMetaData _$SucreMetaDataFromJson(Map<String, dynamic> json) =>
    SucreMetaData(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$SucreMetaDataToJson(SucreMetaData instance) =>
    <String, dynamic>{
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };
