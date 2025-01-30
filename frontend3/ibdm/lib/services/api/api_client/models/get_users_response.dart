// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'get_users_response.g.dart';

/// response of getUsers
@JsonSerializable()
class GetUsersResponse {
  const GetUsersResponse({
    required this.perPage,
    required this.currentPage,
    required this.nbrTotalPages,
    required this.nbrTotalUsers,
    required this.users,
  });
  
  factory GetUsersResponse.fromJson(Map<String, Object?> json) => _$GetUsersResponseFromJson(json);
  
  final int perPage;
  final int currentPage;
  final int nbrTotalPages;
  final int nbrTotalUsers;
  final List<User> users;

  Map<String, Object?> toJson() => _$GetUsersResponseToJson(this);
}
