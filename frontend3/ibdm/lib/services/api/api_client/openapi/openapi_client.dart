// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/logout_response.dart';

part 'openapi_client.g.dart';

@RestApi()
abstract class OpenapiClient {
  factory OpenapiClient(Dio dio, {String? baseUrl}) = _OpenapiClient;

  /// Login.
  ///
  /// Login.
  @FormUrlEncoded()
  @POST('/api/auth/login')
  Future<LoginResponse> login({
    @Body() required LoginRequest body,
  });

  /// Logout.
  ///
  /// Logout.
  @POST('/api/auth/logout')
  Future<LogoutResponse> logout();

  /// Dashboard.
  ///
  /// Dashboard.
  @GET('/api/auth/dashboard')
  Future<LoginResponse> dashboard();
}
