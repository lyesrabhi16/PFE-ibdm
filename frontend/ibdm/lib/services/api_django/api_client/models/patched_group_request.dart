// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'patched_group_request.g.dart';

@JsonSerializable()
class PatchedGroupRequest {
  const PatchedGroupRequest({
    required this.name,
  });
  
  factory PatchedGroupRequest.fromJson(Map<String, Object?> json) => _$PatchedGroupRequestFromJson(json);
  
  final String name;

  Map<String, Object?> toJson() => _$PatchedGroupRequestToJson(this);
}
