// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  const Group({
    required this.groupId,
    required this.name,
  });
  
  factory Group.fromJson(Map<String, Object?> json) => _$GroupFromJson(json);
  
  @JsonKey(name: 'group_id')
  final int groupId;
  final String name;

  Map<String, Object?> toJson() => _$GroupToJson(this);
}
