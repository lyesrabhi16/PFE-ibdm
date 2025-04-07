// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_perms.g.dart';

@JsonSerializable()
class UserPerms {
  const UserPerms({
    required this.perms,
  });
  
  factory UserPerms.fromJson(Map<String, Object?> json) => _$UserPermsFromJson(json);
  
  final List<String> perms;

  Map<String, Object?> toJson() => _$UserPermsToJson(this);
}
