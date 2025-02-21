// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'permission.dart';

part 'paginated_permission_list.g.dart';

@JsonSerializable()
class PaginatedPermissionList {
  const PaginatedPermissionList({
    required this.totalPages,
    required this.totalResults,
    required this.perPage,
    required this.currentPage,
    required this.data,
    this.nextUrl,
    this.previousUrl,
  });
  
  factory PaginatedPermissionList.fromJson(Map<String, Object?> json) => _$PaginatedPermissionListFromJson(json);
  
  @JsonKey(name: 'next_url')
  final String? nextUrl;
  @JsonKey(name: 'previous_url')
  final String? previousUrl;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'current_page')
  final int currentPage;
  final List<Permission> data;

  Map<String, Object?> toJson() => _$PaginatedPermissionListToJson(this);
}
