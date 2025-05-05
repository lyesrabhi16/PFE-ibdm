// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ReportType {
  @JsonValue('co2_ifruit')
  co2Ifruit('co2_ifruit'),
  @JsonValue('filtration')
  filtration('filtration'),
  @JsonValue('inventaire-sucre')
  inventaireSucre('inventaire-sucre'),
  @JsonValue('utilite')
  utilite('utilite'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ReportType(this.json);

  factory ReportType.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
