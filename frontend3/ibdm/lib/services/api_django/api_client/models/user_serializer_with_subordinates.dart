// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user_serializer_with_subordinates.dart';

part 'user_serializer_with_subordinates.g.dart';

@JsonSerializable()
class UserSerializerWithSubordinates {
  const UserSerializerWithSubordinates({
    required this.url,
    required this.userId,
    required this.email,
    required this.username,
    required this.subordinates,
  });
  
  factory UserSerializerWithSubordinates.fromJson(Map<String, Object?> json) => _$UserSerializerWithSubordinatesFromJson(json);
  
  final String url;
  @JsonKey(name: 'user_id')
  final int userId;
  final String email;
  final String username;
  final List<UserSerializerWithSubordinates> subordinates;

  Map<String, Object?> toJson() => _$UserSerializerWithSubordinatesToJson(this);
}
