// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/alert_email.dart';
import '../models/alert_email_request.dart';
import '../models/co2_ifruit.dart';
import '../models/co2_ifruit_consommation.dart';
import '../models/debit.dart';
import '../models/email_schedule.dart';
import '../models/email_schedule_request.dart';
import '../models/feed_meta_data.dart';
import '../models/format.dart';
import '../models/get_subordinate_and_superior_id_response.dart';
import '../models/group.dart';
import '../models/group_request.dart';
import '../models/has_perm_response.dart';
import '../models/interval.dart';
import '../models/lang.dart';
import '../models/login_request_request.dart';
import '../models/login_response.dart';
import '../models/niveau.dart';
import '../models/paginated_alert_email_list.dart';
import '../models/paginated_co2_ifruit_list.dart';
import '../models/paginated_debit_list.dart';
import '../models/paginated_email_schedule_list.dart';
import '../models/paginated_group_list.dart';
import '../models/paginated_niveau_list.dart';
import '../models/paginated_permission_list.dart';
import '../models/paginated_pres_cond_list.dart';
import '../models/paginated_role_list.dart';
import '../models/paginated_sent_email_list.dart';
import '../models/paginated_subordinate_and_superior_list.dart';
import '../models/paginated_sucre_list.dart';
import '../models/paginated_user_list.dart';
import '../models/paginated_utilite_list.dart';
import '../models/paginated_volume_list.dart';
import '../models/patched_alert_email_request.dart';
import '../models/patched_email_schedule_request.dart';
import '../models/patched_group_request.dart';
import '../models/patched_permission_request.dart';
import '../models/patched_role_request.dart';
import '../models/patched_subordinate_and_superior_request.dart';
import '../models/permission.dart';
import '../models/permission_request.dart';
import '../models/possible_monitor_values_alert_emails.dart';
import '../models/pres_cond.dart';
import '../models/rapport.dart';
import '../models/role.dart';
import '../models/role_request.dart';
import '../models/sent_email.dart';
import '../models/subordinate_and_superior.dart';
import '../models/subordinate_and_superior_request.dart';
import '../models/success_response.dart';
import '../models/sucre.dart';
import '../models/user.dart';
import '../models/utilite.dart';
import '../models/volume.dart';

part 'ibdm_api_client.g.dart';

@RestApi()
abstract class IbdmApiClient {
  factory IbdmApiClient(Dio dio, {String? baseUrl}) = _IbdmApiClient;

  @POST('/api/v1/auth/login')
  Future<LoginResponse> login({
    @Body() required LoginRequestRequest body,
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
  /// [ordering] - Which field to use when ordering the results.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  ///
  /// [search] - A search term.
  @GET('/api/v1/emails/alerts/')
  Future<PaginatedAlertEmailList> getAlertEmails({
    @Query('enable_pagination') bool? enablePagination,
    @Query('enabled') bool? enabled,
    @Query('ordering') String? ordering,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
    @Query('search') String? search,
    @Query('tag') String? tag,
  });

  @POST('/api/v1/emails/alerts/')
  Future<AlertEmail> addAlertEmail({
    @Body() required AlertEmailRequest body,
  });

  /// [id] - A unique integer value identifying this alert email.
  @GET('/api/v1/emails/alerts/{id}/')
  Future<AlertEmail> getAlertEmail({
    @Path('id') required int id,
  });

  /// [id] - A unique integer value identifying this alert email.
  @PUT('/api/v1/emails/alerts/{id}/')
  Future<AlertEmail> updateAlertEmail({
    @Path('id') required int id,
    @Body() required AlertEmailRequest body,
  });

  /// [id] - A unique integer value identifying this alert email.
  @PATCH('/api/v1/emails/alerts/{id}/')
  Future<AlertEmail> partialUpdateAlertEmail({
    @Path('id') required int id,
    @Body() PatchedAlertEmailRequest? body,
  });

  /// [id] - A unique integer value identifying this alert email.
  @DELETE('/api/v1/emails/alerts/{id}/')
  Future<void> destroyAlertEmail({
    @Path('id') required int id,
  });

  /// Get possible monitor values for alert emails
  @GET('/api/v1/emails/monitored-values')
  Future<PossibleMonitorValuesAlertEmails> getPossibleMonitorValuesAlertEmails();

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [interval] - * `jour` - jour.
  /// * `semaine` - semaine.
  /// * `mois` - mois.
  /// * `manual` - manual.
  ///
  /// [ordering] - Which field to use when ordering the results.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  ///
  /// [rapport] - * `inventaire-sucre` - inventaire-sucre.
  /// * `utilite` - utilite.
  /// * `filtration` - filtration.
  ///
  /// [search] - A search term.
  @GET('/api/v1/emails/schedules/')
  Future<PaginatedEmailScheduleList> getEmailSchedules({
    @Query('enable_pagination') bool? enablePagination,
    @Query('interval') Interval? interval,
    @Query('ordering') String? ordering,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
    @Query('rapport') Rapport? rapport,
    @Query('search') String? search,
  });

  @POST('/api/v1/emails/schedules/')
  Future<EmailSchedule> addEmailSchedule({
    @Body() required EmailScheduleRequest body,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @GET('/api/v1/emails/schedules/{id}/')
  Future<EmailSchedule> getEmailSchedule({
    @Path('id') required int id,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @PUT('/api/v1/emails/schedules/{id}/')
  Future<EmailSchedule> updateEmailSchedule({
    @Path('id') required int id,
    @Body() required EmailScheduleRequest body,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @PATCH('/api/v1/emails/schedules/{id}/')
  Future<EmailSchedule> partialUpdateEmailSchedule({
    @Path('id') required int id,
    @Body() PatchedEmailScheduleRequest? body,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @DELETE('/api/v1/emails/schedules/{id}/')
  Future<void> destroyEmailSchedule({
    @Path('id') required int id,
  });

  /// Send scheduled email now
  @POST('/api/v1/emails/send/schedule/{email_schedule_id}')
  Future<SuccessResponse> sendScheduledEmailNow({
    @Path('email_schedule_id') required int emailScheduleId,
  });

  /// get sent emails.
  ///
  /// Get all sent emails.
  ///
  /// [emailType] - Filter by alert or schedule.
  ///
  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [ordering] - Order by temps_envois, receptionist.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  ///
  /// [search] - Search by receptionist__username, receptionist__email, receptionist__first_name, receptionist__last_name, schedule__rapport, alert__monitored_value.
  @GET('/api/v1/emails/sent/')
  Future<PaginatedSentEmailList> getSentEmails({
    @Query('email_type') String? emailType,
    @Query('enable_pagination') bool? enablePagination,
    @Query('ordering') String? ordering,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
    @Query('search') String? search,
  });

  /// [id] - A unique integer value identifying this sent email.
  @GET('/api/v1/emails/sent/{id}/')
  Future<SentEmail> getSentEmail({
    @Path('id') required int id,
  });

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/filtration/debit/')
  Future<PaginatedDebitList> getDebits({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this debit.
  @GET('/api/v1/filtration/debit/{date}/')
  Future<Debit> getDebit({
    @Path('date') required DateTime date,
  });

  /// getDebitAtSpecificTime
  @GET('/api/v1/filtration/debit/specific')
  Future<Debit> getDebitAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
  });

  @GET('/api/v1/filtration/metadata')
  Future<FeedMetaData> getFiltrationMetaData();

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/filtration/niveau/')
  Future<PaginatedNiveauList> getNiveaux({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this niveau.
  @GET('/api/v1/filtration/niveau/{date}/')
  Future<Niveau> getNiveau({
    @Path('date') required DateTime date,
  });

  /// getNiveauAtSpecificTime
  @GET('/api/v1/filtration/niveau/specific')
  Future<Niveau> getNiveauAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
  });

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/filtration/pres-cond/')
  Future<PaginatedPresCondList> getPresConds({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this pres cond.
  @GET('/api/v1/filtration/pres-cond/{date}/')
  Future<PresCond> getPresCond({
    @Path('date') required DateTime date,
  });

  /// getPresCondAtSpecificTime
  @GET('/api/v1/filtration/pres-cond/specific')
  Future<PresCond> getPresCondAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
  });

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/filtration/volume/')
  Future<PaginatedVolumeList> getVolumes({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this volume.
  @GET('/api/v1/filtration/volume/{date}/')
  Future<Volume> getVolume({
    @Path('date') required DateTime date,
  });

  /// getVolumeAtSpecificTime
  @GET('/api/v1/filtration/volume/specific')
  Future<Volume> getVolumeAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
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
  Future<FeedMetaData> getSucreMetaData();

  /// getSucreAtSpecificTime
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
  @POST('/api/v1/user-management/groups/')
  Future<Group> addGroup({
    @Body() required GroupRequest body,
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
  @PUT('/api/v1/user-management/groups/{id}/')
  Future<Group> updateGroup({
    @Path('id') required int id,
    @Body() required GroupRequest body,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this group.
  @PATCH('/api/v1/user-management/groups/{id}/')
  Future<Group> partialUpdateGroup({
    @Path('id') required int id,
    @Body() PatchedGroupRequest? body,
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
  @POST('/api/v1/user-management/permissions/')
  Future<Permission> addPermission({
    @Body() required PermissionRequest body,
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
  @PUT('/api/v1/user-management/permissions/{id}/')
  Future<Permission> updatePermission({
    @Path('id') required int id,
    @Body() required PermissionRequest body,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this permission.
  @PATCH('/api/v1/user-management/permissions/{id}/')
  Future<Permission> partialUpdatePermission({
    @Path('id') required int id,
    @Body() PatchedPermissionRequest? body,
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
  @POST('/api/v1/user-management/roles/')
  Future<Role> addRole({
    @Body() required RoleRequest body,
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
  @PUT('/api/v1/user-management/roles/{id}/')
  Future<Role> updateRole({
    @Path('id') required int id,
    @Body() required RoleRequest body,
  });

  /// API endpoint that allows groups to be viewed or edited.
  ///
  /// [id] - A unique integer value identifying this role.
  @PATCH('/api/v1/user-management/roles/{id}/')
  Future<Role> partialUpdateRole({
    @Path('id') required int id,
    @Body() PatchedRoleRequest? body,
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

  @POST('/api/v1/user-management/subordinates_superiors/')
  Future<SubordinateAndSuperior> addSubordinateAndSuperior({
    @Body() required SubordinateAndSuperiorRequest body,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @GET('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<SubordinateAndSuperior> getSubordinateAndSuperior({
    @Path('id') required int id,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @PUT('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<SubordinateAndSuperior> updateSubordinateAndSuperior({
    @Path('id') required int id,
    @Body() required SubordinateAndSuperiorRequest body,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @PATCH('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<SubordinateAndSuperior> partialUpdateSubordinateAndSuperior({
    @Path('id') required int id,
    @Body() PatchedSubordinateAndSuperiorRequest? body,
  });

  /// [id] - A unique integer value identifying this subordinate and superior.
  @DELETE('/api/v1/user-management/subordinates_superiors/{id}/')
  Future<void> removeSubordinateAndSuperior({
    @Path('id') required int id,
  });

  /// Get the id of the SubordinateAndSuperior object that links the current user to their superior
  @GET('/api/v1/user-management/subordinates_superiors/{subordinate}/{superior}/')
  Future<GetSubordinateAndSuperiorIdResponse> getSubordinateAndSuperiorId({
    @Path('subordinate') required int subordinate,
    @Path('superior') required int superior,
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

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/utilite/co2_ifruit/')
  Future<PaginatedCo2IfruitList> getCo2IfruitList({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this co2 ifruit.
  @GET('/api/v1/utilite/co2_ifruit/{date}/')
  Future<Co2Ifruit> getCo2Ifruit({
    @Path('date') required DateTime date,
  });

  /// get co2_ifruit consommation.
  ///
  /// getCo2IfruitConsommation.
  @GET('/api/v1/utilite/co2_ifruit/consommation')
  Future<Co2IfruitConsommation> getCo2IfruitConsommation({
    @Query('from_year') required int fromYear,
    @Query('to_year') required int toYear,
    @Query('from_day') int? fromDay,
    @Query('from_month') int? fromMonth,
    @Query('to_day') int? toDay,
    @Query('to_month') int? toMonth,
  });

  /// get Co2_Ifruit at specific time.
  ///
  /// getCo2IfruitAtSpecificTime.
  @GET('/api/v1/utilite/co2_ifruit/specific')
  Future<Co2Ifruit> getCo2IfruitAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
  });

  /// get utilite metadata
  @GET('/api/v1/utilite/metadata')
  Future<FeedMetaData> getUtiliteMetaData();

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/utilite/utilite/')
  Future<PaginatedUtiliteList> getUtiliteList({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  /// [date] - A unique value identifying this utilite.
  @GET('/api/v1/utilite/utilite/{date}/')
  Future<Utilite> getUtilite({
    @Path('date') required DateTime date,
  });

  /// get utilite at specific time.
  ///
  /// getUtiliteAtSpecificTime.
  @GET('/api/v1/utilite/utilite/specific')
  Future<Utilite> getUtiliteAtSpecificTime({
    @Query('year') required int year,
    @Query('day') int? day,
    @Query('hour') int? hour,
    @Query('minute') int? minute,
    @Query('month') int? month,
    @Query('second') int? second,
  });

  /// Get the CA certificate
  @GET('/ca')
  Future<String> getCA();
}
