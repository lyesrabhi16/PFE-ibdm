// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `invalid_input` - invalid_input.
/// * `invalid_credentials` - invalid_credentials.
/// * `not_found` - not_found.
/// * `server_error` - server_error.
@JsonEnum()
enum CodeEnum {
  @JsonValue('invalid_input')
  invalidInput('invalid_input'),
  @JsonValue('invalid_credentials')
  invalidCredentials('invalid_credentials'),
  @JsonValue('not_found')
  notFound('not_found'),
  @JsonValue('server_error')
  serverError('server_error'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CodeEnum(this.json);

  factory CodeEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
