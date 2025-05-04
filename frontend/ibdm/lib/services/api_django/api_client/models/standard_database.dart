// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'database_storage_info.dart';

part 'standard_database.g.dart';

@JsonSerializable()
class StandardDatabase {
  const StandardDatabase({
    required this.state,
    required this.info,
    required this.query,
  });
  
  factory StandardDatabase.fromJson(Map<String, Object?> json) => _$StandardDatabaseFromJson(json);
  
  final String state;
  final Map<String, DatabaseStorageInfo>? info;
  final String? query;

  Map<String, Object?> toJson() => _$StandardDatabaseToJson(this);
}
