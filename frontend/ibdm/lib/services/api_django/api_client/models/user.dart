// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user_serializer_with_subordinates.dart';
import 'user_serializer_with_superiors.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.role,
    required this.superiors,
    required this.subordinates,
    required this.userPermissions,
    required this.isAdmin,
  });
  
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
  
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String username;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String role;
  final List<UserSerializerWithSuperiors> superiors;
  final List<UserSerializerWithSubordinates> subordinates;

  /// Specific permissions for this user.
  @JsonKey(name: 'user_permissions')
  final List<int> userPermissions;
  @JsonKey(name: 'is_admin')
  final bool isAdmin;

  Map<String, Object?> toJson() => _$UserToJson(this);
}
