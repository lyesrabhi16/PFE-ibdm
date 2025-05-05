// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum FetchType {
  @JsonValue('all')
  all('all'),
  @JsonValue('days')
  days('days'),
  @JsonValue('hours')
  hours('hours'),
  @JsonValue('minutes')
  minutes('minutes'),
  @JsonValue('months')
  months('months'),
  @JsonValue('seconds')
  seconds('seconds'),
  @JsonValue('weeks')
  weeks('weeks'),
  @JsonValue('years')
  years('years'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const FetchType(this.json);

  factory FetchType.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
