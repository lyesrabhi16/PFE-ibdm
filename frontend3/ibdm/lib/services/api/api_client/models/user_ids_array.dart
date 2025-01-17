// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_ids_array.g.dart';

@JsonSerializable()
class UserIdsArray {
  const UserIdsArray({
    required this.property,
  });
  
  factory UserIdsArray.fromJson(Map<String, Object?> json) => _$UserIdsArrayFromJson(json);
  
  final String property;

  Map<String, Object?> toJson() => _$UserIdsArrayToJson(this);
}
