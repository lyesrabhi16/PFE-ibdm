// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sucre_meta_data.g.dart';

@JsonSerializable()
class SucreMetaData {
  const SucreMetaData({
    required this.startDate,
    required this.endDate,
  });
  
  factory SucreMetaData.fromJson(Map<String, Object?> json) => _$SucreMetaDataFromJson(json);
  
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  Map<String, Object?> toJson() => _$SucreMetaDataToJson(this);
}
