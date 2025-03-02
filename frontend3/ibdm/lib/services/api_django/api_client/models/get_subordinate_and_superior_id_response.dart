// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'get_subordinate_and_superior_id_response.g.dart';

@JsonSerializable()
class GetSubordinateAndSuperiorIdResponse {
  const GetSubordinateAndSuperiorIdResponse({
    required this.id,
  });
  
  factory GetSubordinateAndSuperiorIdResponse.fromJson(Map<String, Object?> json) => _$GetSubordinateAndSuperiorIdResponseFromJson(json);
  
  final int id;

  Map<String, Object?> toJson() => _$GetSubordinateAndSuperiorIdResponseToJson(this);
}
