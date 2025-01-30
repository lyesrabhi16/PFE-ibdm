// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'role.dart';

part 'add_user_input.g.dart';

@JsonSerializable()
class AddUserInput {
  const AddUserInput({
    required this.email,
    required this.password,
    required this.role,
    this.name,
    this.phoneNumber,
    this.superiorId,
  });
  
  factory AddUserInput.fromJson(Map<String, Object?> json) => _$AddUserInputFromJson(json);
  
  final String email;
  final String password;
  final String? name;
  final Role role;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'superior_id')
  final String? superiorId;

  Map<String, Object?> toJson() => _$AddUserInputToJson(this);
}
