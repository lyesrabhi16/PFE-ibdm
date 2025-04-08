// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'database_storage_info.g.dart';

@JsonSerializable()
class DatabaseStorageInfo {
  const DatabaseStorageInfo({
    required this.used,
    required this.available,
    required this.total,
    required this.percent,
  });
  
  factory DatabaseStorageInfo.fromJson(Map<String, Object?> json) => _$DatabaseStorageInfoFromJson(json);
  
  final int used;
  final int available;
  final int total;
  final double percent;

  Map<String, Object?> toJson() => _$DatabaseStorageInfoToJson(this);
}
