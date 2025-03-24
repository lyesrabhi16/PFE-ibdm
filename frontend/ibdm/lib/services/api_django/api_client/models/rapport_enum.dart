// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `inventaire-sucre` - inventaire-sucre.
/// * `utilite` - utilite.
/// * `filtration` - filtration.
@JsonEnum()
enum RapportEnum {
  @JsonValue('inventaire-sucre')
  inventaireSucre('inventaire-sucre'),
  @JsonValue('utilite')
  utilite('utilite'),
  @JsonValue('filtration')
  filtration('filtration'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const RapportEnum(this.json);

  factory RapportEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
