// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_subordinate_and_superior_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedSubordinateAndSuperiorList
    _$PaginatedSubordinateAndSuperiorListFromJson(Map<String, dynamic> json) =>
        PaginatedSubordinateAndSuperiorList(
          totalPages: (json['total_pages'] as num).toInt(),
          totalResults: (json['total_results'] as num).toInt(),
          perPage: (json['per_page'] as num).toInt(),
          currentPage: (json['current_page'] as num).toInt(),
          data: (json['data'] as List<dynamic>)
              .map((e) =>
                  SubordinateAndSuperior.fromJson(e as Map<String, dynamic>))
              .toList(),
          nextUrl: json['next_url'] as String?,
          previousUrl: json['previous_url'] as String?,
        );

Map<String, dynamic> _$PaginatedSubordinateAndSuperiorListToJson(
        PaginatedSubordinateAndSuperiorList instance) =>
    <String, dynamic>{
      'next_url': instance.nextUrl,
      'previous_url': instance.previousUrl,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'data': instance.data,
    };
