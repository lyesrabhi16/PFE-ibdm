// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'co2_ifruit.dart';

part 'paginated_co2_ifruit_list.g.dart';

@JsonSerializable()
class PaginatedCo2IfruitList {
  const PaginatedCo2IfruitList({
    required this.totalPages,
    required this.totalResults,
    required this.perPage,
    required this.currentPage,
    required this.data,
    this.nextUrl,
    this.previousUrl,
  });
  
  factory PaginatedCo2IfruitList.fromJson(Map<String, Object?> json) => _$PaginatedCo2IfruitListFromJson(json);
  
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
  final List<Co2Ifruit> data;

  Map<String, Object?> toJson() => _$PaginatedCo2IfruitListToJson(this);
}
