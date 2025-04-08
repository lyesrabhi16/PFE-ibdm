// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standard_database.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandardDatabase _$StandardDatabaseFromJson(Map<String, dynamic> json) =>
    StandardDatabase(
      state: json['state'] as String,
      info: (json['info'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, DatabaseStorageInfo.fromJson(e as Map<String, dynamic>)),
      ),
      query: json['query'] as String,
    );

Map<String, dynamic> _$StandardDatabaseToJson(StandardDatabase instance) =>
    <String, dynamic>{
      'state': instance.state,
      'info': instance.info,
      'query': instance.query,
    };
