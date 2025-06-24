// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `JOURS` - JOURS.
/// * `MINUTES` - MINUTES.
@JsonEnum()
enum ReminderIntervalUnitEnum {
  @JsonValue('JOURS')
  jours('JOURS'),
  @JsonValue('MINUTES')
  minutes('MINUTES'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ReminderIntervalUnitEnum(this.json);

  factory ReminderIntervalUnitEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
