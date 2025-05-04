// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'redis_database.dart';
import 'standard_database.dart';

part 'databases.g.dart';

@JsonSerializable()
class Databases {
  const Databases({
    required this.ibdm,
    required this.siroperie,
    required this.filtration,
    required this.utilite,
    required this.ibdmRedis,
  });
  
  factory Databases.fromJson(Map<String, Object?> json) => _$DatabasesFromJson(json);
  
  final StandardDatabase ibdm;
  final StandardDatabase siroperie;
  final StandardDatabase filtration;
  final StandardDatabase utilite;
  @JsonKey(name: 'ibdm_redis')
  final RedisDatabase ibdmRedis;

  Map<String, Object?> toJson() => _$DatabasesToJson(this);
}
