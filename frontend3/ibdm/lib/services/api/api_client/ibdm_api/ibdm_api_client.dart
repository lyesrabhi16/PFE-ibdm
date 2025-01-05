// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/get_user_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/logout_response.dart';

part 'ibdm_api_client.g.dart';

@RestApi()
abstract class IbdmApiClient {
  factory IbdmApiClient(Dio dio, {String? baseUrl}) = _IbdmApiClient;

  /// Get the OpenAPI specification in json format.
  ///
  /// Get the OpenAPI specification.
  @GET('/api/documentation/openapi.json')
  Future<dynamic> getOpenApiSpecificationJson();

  /// Get the Swagger UI
  @GET('/api/documentation')
  Future<String> getDocumentationUi();

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

  /// Get user.
  ///
  /// Get user.
  @GET('/api/auth/user/me')
  Future<GetUserResponse> getUser();
}
