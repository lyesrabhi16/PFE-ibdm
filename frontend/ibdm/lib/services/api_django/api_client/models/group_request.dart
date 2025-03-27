// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'group_request.g.dart';

@JsonSerializable()
class GroupRequest {
  const GroupRequest({
    required this.name,
  });
  
  factory GroupRequest.fromJson(Map<String, Object?> json) => _$GroupRequestFromJson(json);
  
  final String name;

  Map<String, Object?> toJson() => _$GroupRequestToJson(this);
}
