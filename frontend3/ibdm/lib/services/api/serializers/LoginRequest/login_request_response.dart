import 'package:json_annotation/json_annotation.dart';

part "login_request_response.g.dart";

@JsonSerializable()
class LoginRequestResponse {
  final String? token;
  const LoginRequestResponse({this.token});

  factory LoginRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestResponseToJson(this);
}
