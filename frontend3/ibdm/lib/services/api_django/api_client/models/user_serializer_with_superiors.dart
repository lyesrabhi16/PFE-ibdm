// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user_serializer_with_superiors.dart';

part 'user_serializer_with_superiors.g.dart';

@JsonSerializable()
class UserSerializerWithSuperiors {
  const UserSerializerWithSuperiors({
    required this.url,
    required this.userId,
    required this.email,
    required this.username,
    required this.superiors,
  });
  
  factory UserSerializerWithSuperiors.fromJson(Map<String, Object?> json) => _$UserSerializerWithSuperiorsFromJson(json);
  
  final String url;
  @JsonKey(name: 'user_id')
  final int userId;
  final String email;
  final String username;
  final List<UserSerializerWithSuperiors> superiors;

  Map<String, Object?> toJson() => _$UserSerializerWithSuperiorsToJson(this);
}
