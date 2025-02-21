// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/delete_api_users_id_response.dart';
import '../models/delete_api_users_response.dart';
import '../models/get_api_users_id_response.dart';
import '../models/get_user_response.dart';
import '../models/get_users_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/logout_response.dart';
import '../models/post_api_users_response.dart';
import '../models/role.dart';
import '../models/user.dart';
import '../models/user_ids_array.dart';
import 'package:http/http.dart' as http;

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
  Future<GetUserResponse> getCurrentUser();

  /// get users.
  ///
  /// get users.
  ///
  /// [page] - page number, default 1.
  ///
  /// [perPage] - number of items per page, default 10.
  ///
  /// [enablePagination] - enable pagination, default true.
  @GET('/api/users')
  Future<GetUsersResponse> getUsers({
    @Query('page') num? page,
    @Query('perPage') num? perPage,
    @Query('enablePagination') bool? enablePagination,
  });

  /// add a user.
  ///
  /// add a user.
  @MultiPart()
  @POST('/api/users')
  Future<PostApiUsersResponse> addUser({
    @Part(name: 'email') required String email,
    @Part(name: 'password') required String password,
    @Part(name: 'role') required Role role,
    @Part(name: 'avatar') File? avatar,
    @Part(name: 'name') String? name,
    @Part(name: 'phone_number') String? phoneNumber,
    @Part(name: 'superior_id') String? superiorId,
  });

  /// delete many users.
  ///
  /// delete many users.
  ///
  /// [userIds] - an array of user ids (strings).
  @DELETE('/api/users')
  Future<DeleteApiUsersResponse> deleteUsers({
    @Query('userIds') required UserIdsArray userIds,
  });

  /// get the info of a user.
  ///
  /// get the info of a user.
  @GET('/api/users/{id}')
  Future<GetApiUsersIdResponse> getUser({
    @Path('id') required String id,
  });

  /// delete a user.
  ///
  /// delete a user.
  @DELETE('/api/users/{id}')
  Future<DeleteApiUsersIdResponse> deleteUser({
    @Path('id') required String id,
  });

  /// update a user.
  ///
  /// update a user.
  @PUT('/api/users/{id}')
  Future<User> updateUser({
    @Path('id') required String id,
    @Body() User? body,
  });
}
