// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `production` - production.
/// * `development` - development.
@JsonEnum()
enum EnvmodeEnum {
  @JsonValue('production')
  production('production'),
  @JsonValue('development')
  development('development'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const EnvmodeEnum(this.json);

  factory EnvmodeEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
