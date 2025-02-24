// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_volume_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedVolumeList _$PaginatedVolumeListFromJson(Map<String, dynamic> json) =>
    PaginatedVolumeList(
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Volume.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextUrl: json['next_url'] as String?,
      previousUrl: json['previous_url'] as String?,
    );

Map<String, dynamic> _$PaginatedVolumeListToJson(
        PaginatedVolumeList instance) =>
    <String, dynamic>{
      'next_url': instance.nextUrl,
      'previous_url': instance.previousUrl,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'data': instance.data,
    };
