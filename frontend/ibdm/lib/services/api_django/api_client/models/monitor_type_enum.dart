// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// * `ASC` - ASC.
/// * `DESC` - DESC.
@JsonEnum()
enum MonitorTypeEnum {
  @JsonValue('ASC')
  asc('ASC'),
  @JsonValue('DESC')
  desc('DESC'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const MonitorTypeEnum(this.json);

  factory MonitorTypeEnum.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;
}
