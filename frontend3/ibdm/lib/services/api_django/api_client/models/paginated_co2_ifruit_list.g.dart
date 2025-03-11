// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_co2_ifruit_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedCo2IfruitList _$PaginatedCo2IfruitListFromJson(
        Map<String, dynamic> json) =>
    PaginatedCo2IfruitList(
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Co2Ifruit.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextUrl: json['next_url'] as String?,
      previousUrl: json['previous_url'] as String?,
    );

Map<String, dynamic> _$PaginatedCo2IfruitListToJson(
        PaginatedCo2IfruitList instance) =>
    <String, dynamic>{
      'next_url': instance.nextUrl,
      'previous_url': instance.previousUrl,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'data': instance.data,
    };
