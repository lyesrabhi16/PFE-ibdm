// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/format.dart';
import '../models/group.dart';
import '../models/has_perm_response.dart';
import '../models/lang.dart';
import '../models/login_response.dart';
import '../models/paginated_group_list.dart';
import '../models/paginated_permission_list.dart';
import '../models/paginated_role_list.dart';
import '../models/paginated_subordinate_and_superior_list.dart';
import '../models/paginated_sucre_list.dart';
import '../models/paginated_user_list.dart';
import '../models/permission.dart';
import '../models/role.dart';
import '../models/subordinate_and_superior.dart';
import '../models/success_response.dart';
import '../models/sucre.dart';
import '../models/sucre_meta_data.dart';
import '../models/user.dart';

part 'ibdm_api_client.g.dart';

@RestApi()
abstract class IbdmApiClient {
  factory IbdmApiClient(Dio dio, {String? baseUrl}) = _IbdmApiClient;

  @MultiPart()
  @POST('/api/v1/auth/login')
  Future<LoginResponse> login({
    @Part(name: 'email') required String email,
    @Part(name: 'password') required String password,
  });

  @POST('/api/v1/auth/logout')
  Future<SuccessResponse> logout();

  @GET('/api/v1/auth/user/me')
  Future<User> getCurrentUserInfo();

  @GET('/api/v1/auth/user/permission/{codename}')
  Future<HasPermResponse> hasPerm({
    @Path('codename') required String codename,
  });

  /// OpenApi3 schema for this API. Format can be selected via content negotiation.
  ///
  /// - YAML: application/vnd.oai.openapi.
  /// - JSON: application/vnd.oai.openapi+json.
  @GET('/api/v1/docs/schema/')
  Future<dynamic> retrieveApiV1DocsSchema({
    @Query('format') Format? format,
    @Query('lang') Lang? lang,
  });

  /// OpenApi3 schema for this API. Format can be selected via content negotiation.
  ///
  /// - YAML: application/vnd.oai.openapi.
  /// - JSON: application/vnd.oai.openapi+json.
  @GET('/api/v1/documentation/schema/')
  Future<dynamic> retrieveApiV1DocumentationSchema({
    @Query('format') Format? format,
    @Query('lang') Lang? lang,
  });

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/siroperie/sucre/')
  Future<PaginatedSucreList> getSucreList({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this sucre.
  @GET('/api/v1/siroperie/sucre/{date}/')
  Future<Sucre> getSucre({
    @Path('date') required DateTime date,
  });

  @GET('/api/v1/siroperie/sucre/meta')
  Future<SucreMetaData> getSucreMetaData();

  /// getAtSpecificTime
  @GET('/api/v1/siroperie/sucre/specific')
  Future<Sucre> getSucreAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/user-management/groups/')
  Future<PaginatedGroupList> getGroups({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// API endpoint that allows groups to be viewed or edited.
  @MultiPart()
  @POST('/api/v1/user-management/groups/')
  Future<Group> addGroup({
    @Part(name: 'name') required String name,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this group.
  @GET('/api/v1/user-management/groups/{id}/')
  Future<Group> getGroup({
    @Path('id') required int id,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this group.
  @MultiPart()
  @PUT('/api/v1/user-management/groups/{id}/')
  Future<Group> updateGroup({
    @Path('id') required int id,
    @Part(name: 'name') required String name,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this group.
  @MultiPart()
  @PATCH('/api/v1/user-management/groups/{id}/')
  Future<Group> partialUpdateGroup({
    @Path('id') required int id,
    @Part(name: 'name') String? name,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this group.
  @DELETE('/api/v1/user-management/groups/{id}/')
  Future<void> removeGroup({
    @Path('id') required int id,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/user-management/permissions/')
  Future<PaginatedPermissionList> getPermissions({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// API endpoint that allows groups to be viewed or edited.
  @MultiPart()
  @POST('/api/v1/user-management/permissions/')
  Future<Permission> addPermission({
    @Part(name: 'name') required String name,
    @Part(name: 'codename') required String codename,
    @Part(name: 'content_type') required int contentType,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this permission.
  @GET('/api/v1/user-management/permissions/{id}/')
  Future<Permission> getPermission({
    @Path('id') required int id,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this permission.
  @MultiPart()
  @PUT('/api/v1/user-management/permissions/{id}/')
  Future<Permission> updatePermission({
    @Path('id') required int id,
    @Part(name: 'name') required String name,
    @Part(name: 'codename') required String codename,
    @Part(name: 'content_type') required int contentType,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this permission.
  @MultiPart()
  @PATCH('/api/v1/user-management/permissions/{id}/')
  Future<Permission> partialUpdatePermission({
    @Path('id') required int id,
    @Part(name: 'name') String? name,
    @Part(name: 'codename') String? codename,
    @Part(name: 'content_type') int? contentType,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this permission.
  @DELETE('/api/v1/user-management/permissions/{id}/')
  Future<void> removePermission({
    @Path('id') required int id,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/user-management/roles/')
  Future<PaginatedRoleList> getRoles({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// API endpoint that allows groups to be viewed or edited.
  @MultiPart()
  @POST('/api/v1/user-management/roles/')
  Future<Role> addRole({
    @Part(name: 'group_id') required int groupId,
    @Part(name: 'managed_roles') required List<String> managedRoles,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this role.
  @GET('/api/v1/user-management/roles/{id}/')
  Future<Role> getRole({
    @Path('id') required int id,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this role.
  @MultiPart()
  @PUT('/api/v1/user-management/roles/{id}/')
  Future<Role> updateRole({
    @Path('id') required int id,
    @Part(name: 'group_id') required int groupId,
    @Part(name: 'managed_roles') required List<String> managedRoles,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this role.
  @MultiPart()
  @PATCH('/api/v1/user-management/roles/{id}/')
  Future<Role> partialUpdateRole({
    @Path('id') required int id,
    @Part(name: 'group_id') int? groupId,
    @Part(name: 'managed_roles') List<String>? managedRoles,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this role.
  @DELETE('/api/v1/user-management/roles/{id}/')
  Future<void> removeRole({
    @Path('id') required int id,
  });

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/user-management/subordinates_superiors/')
  Future<PaginatedSubordinateAndSuperiorList> getSubordinatesAndSuperiors({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @MultiPart()
  @POST('/api/v1/user-management/subordinates_superiors/')
  Future<SubordinateAndSuperior> addSubordinateAndSuperior({
    @Part(name: 'superior') required int superior,
    @Part(name: 'subordinate') required int subordinate,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @GET('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<SubordinateAndSuperior> getSubordinateAndSuperior({
    @Path('id') required int id,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @MultiPart()
  @PUT('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<SubordinateAndSuperior> updateSubordinateAndSuperior({
    @Path('id') required int id,
    @Part(name: 'superior') required int superior,
    @Part(name: 'subordinate') required int subordinate,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @MultiPart()
  @PATCH('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<SubordinateAndSuperior> partialUpdateSubordinateAndSuperior({
    @Path('id') required int id,
    @Part(name: 'superior') int? superior,
    @Part(name: 'subordinate') int? subordinate,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @DELETE('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<void> removeSubordinateAndSuperior({
    @Path('id') required int id,
  });

  /// API endpoint that allows users to be viewed or edited.
  ///
  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [ordering] - Which field to use when ordering the results.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  ///
  /// [search] - A search term.
  @GET('/api/v1/user-management/users/')
  Future<PaginatedUserList> getUsers({
    @Query('enable_pagination') bool? enablePagination,
    @Query('ordering') String? ordering,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
    @Query('role') int? role,
    @Query('search') String? search,
  });

  /// API endpoint that allows users to be viewed or edited.
  ///
  /// [userPermissions] - Specific permissions for this user.
  @MultiPart()
  @POST('/api/v1/user-management/users/')
  Future<User> addUser({
    @Part(name: 'email') required String email,
    @Part(name: 'role') required String role,
    @Part(name: 'first_name') String? firstName,
    @Part(name: 'last_name') String? lastName,
    @Part(name: 'username') String? username,
    @Part(name: 'password') String? password,
    @Part(name: 'phone_number') String? phoneNumber,
    @Part(name: 'avatar') File? avatar,
    @Part(name: 'user_permissions') List<int>? userPermissions,
  });

  /// API endpoint that allows users to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this user.
  @GET('/api/v1/user-management/users/{id}/')
  Future<User> getUser({
    @Path('id') required int id,
  });

  /// API endpoint that allows users to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this user.
  ///
  /// [userPermissions] - Specific permissions for this user.
  @MultiPart()
  @PUT('/api/v1/user-management/users/{id}/')
  Future<User> updateUser({
    @Path('id') required int id,
    @Part(name: 'email') required String email,
    @Part(name: 'role') required String role,
    @Part(name: 'first_name') String? firstName,
    @Part(name: 'last_name') String? lastName,
    @Part(name: 'username') String? username,
    @Part(name: 'password') String? password,
    @Part(name: 'phone_number') String? phoneNumber,
    @Part(name: 'avatar') File? avatar,
    @Part(name: 'user_permissions') List<int>? userPermissions,
  });

  /// API endpoint that allows users to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this user.
  ///
  /// [userPermissions] - Specific permissions for this user.
  @MultiPart()
  @PATCH('/api/v1/user-management/users/{id}/')
  Future<User> partialUpdateUser({
    @Path('id') required int id,
    @Part(name: 'first_name') String? firstName,
    @Part(name: 'last_name') String? lastName,
    @Part(name: 'username') String? username,
    @Part(name: 'email') String? email,
    @Part(name: 'password') String? password,
    @Part(name: 'phone_number') String? phoneNumber,
    @Part(name: 'avatar') File? avatar,
    @Part(name: 'role') String? role,
    @Part(name: 'user_permissions') List<int>? userPermissions,
  });

  /// API endpoint that allows users to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this user.
  @DELETE('/api/v1/user-management/users/{id}/')
  Future<void> removeUser({
    @Path('id') required int id,
  });
}
