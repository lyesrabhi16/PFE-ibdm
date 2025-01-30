// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'role.dart';
import 'superior_and_subordinate.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.phoneNumber,
    this.superiors,
    this.subordinates,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  final String id;
  final String email;
  final String? name;
  final Role role;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final List<SuperiorAndSubordinate>? superiors;
  final List<SuperiorAndSubordinate>? subordinates;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
