// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';

import 'ibdm_api/ibdm_api_client.dart';

/// IBDM API `v1.0.0`.
///
/// API for the IBDM project.
class ApiClient {
  ApiClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  IbdmApiClient? _ibdmApi;

  IbdmApiClient get ibdmApi => _ibdmApi ??= IbdmApiClient(_dio, baseUrl: _baseUrl);
}
