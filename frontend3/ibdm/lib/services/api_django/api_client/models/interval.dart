// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Interval {
  @JsonValue('jour')
  jour('jour'),
  @JsonValue('manual')
  manual('manual'),
  @JsonValue('mois')
  mois('mois'),
  @JsonValue('semaine')
  semaine('semaine'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const Interval(this.json);

  factory Interval.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
