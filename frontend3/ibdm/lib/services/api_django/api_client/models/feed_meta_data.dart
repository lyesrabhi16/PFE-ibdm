// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'feed_meta_data.g.dart';

@JsonSerializable()
class FeedMetaData {
  const FeedMetaData({
    required this.startDate,
    required this.endDate,
  });
  
  factory FeedMetaData.fromJson(Map<String, Object?> json) => _$FeedMetaDataFromJson(json);
  
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  Map<String, Object?> toJson() => _$FeedMetaDataToJson(this);
}
