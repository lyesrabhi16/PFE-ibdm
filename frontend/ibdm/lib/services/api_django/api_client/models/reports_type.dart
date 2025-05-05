// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ReportsType {
  @JsonValue('Filtration')
  filtration('Filtration'),
  @JsonValue('co2')
  co2('co2'),
  @JsonValue('sucre')
  sucre('sucre'),
  @JsonValue('utilite')
  utilite('utilite'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ReportsType(this.json);

  factory ReportsType.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
