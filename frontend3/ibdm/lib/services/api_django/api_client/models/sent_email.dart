// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'sent_email.g.dart';

@JsonSerializable()
class SentEmail {
  const SentEmail({
    required this.url,
    required this.tempsEnvoi,
    required this.receptionist,
    required this.schedule,
  });
  
  factory SentEmail.fromJson(Map<String, Object?> json) => _$SentEmailFromJson(json);
  
  final String url;
  @JsonKey(name: 'temps_envoi')
  final DateTime tempsEnvoi;
  final String receptionist;
  final int schedule;

  Map<String, Object?> toJson() => _$SentEmailToJson(this);
}
