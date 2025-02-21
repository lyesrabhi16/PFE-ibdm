// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `jour` - jour.
/// * `semaine` - semaine.
/// * `mois` - mois.
/// * `manual` - manual.
@JsonEnum()
enum IntervalEnum {
  @JsonValue('jour')
  jour('jour'),
  @JsonValue('semaine')
  semaine('semaine'),
  @JsonValue('mois')
  mois('mois'),
  @JsonValue('manual')
  manual('manual'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const IntervalEnum(this.json);

  factory IntervalEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
