// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedMetaData _$FeedMetaDataFromJson(Map<String, dynamic> json) => FeedMetaData(
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$FeedMetaDataToJson(FeedMetaData instance) =>
    <String, dynamic>{
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };
