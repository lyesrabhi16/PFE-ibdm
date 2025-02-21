// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'subordinate_and_superior.dart';

part 'paginated_subordinate_and_superior_list.g.dart';

@JsonSerializable()
class PaginatedSubordinateAndSuperiorList {
  const PaginatedSubordinateAndSuperiorList({
    required this.totalPages,
    required this.totalResults,
    required this.perPage,
    required this.currentPage,
    required this.data,
    this.nextUrl,
    this.previousUrl,
  });
  
  factory PaginatedSubordinateAndSuperiorList.fromJson(Map<String, Object?> json) => _$PaginatedSubordinateAndSuperiorListFromJson(json);
  
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
  final List<SubordinateAndSuperior> data;

  Map<String, Object?> toJson() => _$PaginatedSubordinateAndSuperiorListToJson(this);
}
