// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      status: json['status'] as String,
      code: CodeEnum.fromJson(json['code'] as String),
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'code': _$CodeEnumEnumMap[instance.code]!,
    };

const _$CodeEnumEnumMap = {
  CodeEnum.invalidInput: 'invalid_input',
  CodeEnum.invalidCredentials: 'invalid_credentials',
  CodeEnum.$unknown: r'$unknown',
};
