// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `danger` - danger.
/// * `warning` - warning.
@JsonEnum()
enum AlertTypeEnum {
  @JsonValue('danger')
  danger('danger'),
  @JsonValue('warning')
  warning('warning'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const AlertTypeEnum(this.json);

  factory AlertTypeEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
