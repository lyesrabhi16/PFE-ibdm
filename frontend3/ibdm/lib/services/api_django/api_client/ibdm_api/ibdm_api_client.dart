// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/alert_email.dart';
import '../models/alert_enum.dart';
import '../models/debit.dart';
import '../models/email_schedule.dart';
import '../models/feed_meta_data.dart';
import '../models/format.dart';
import '../models/get_subordinate_and_superior_id_response.dart';
import '../models/group.dart';
import '../models/has_perm_response.dart';
import '../models/interval_enum.dart';
import '../models/lang.dart';
import '../models/login_response.dart';
import '../models/niveau.dart';
import '../models/paginated_alert_email_list.dart';
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
import '../models/paginated_volume_list.dart';
import '../models/permission.dart';
import '../models/possible_monitor_values_alert_emails.dart';
import '../models/pres_cond.dart';
import '../models/rapport_enum.dart';
import '../models/role.dart';
import '../models/sent_email.dart';
import '../models/subordinate_and_superior.dart';
import '../models/success_response.dart';
import '../models/sucre.dart';
import '../models/user.dart';
import '../models/volume.dart';

part 'ibdm_api_client.g.dart';

@RestApi()
abstract class IbdmApiClient {
  factory IbdmApiClient(Dio dio, {String? baseUrl}) = _IbdmApiClient;

  @MultiPart()
  @POST('/api/v1/auth/login')
  Future<LoginResponse> login({
    @Part(name: 'email') required String email,
    @Part(name: 'password') required String password,
    @Part(name: 'remember_me') bool rememberMe = false,
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
  @GET('/api/v1/emails/alerts/')
  Future<PaginatedAlertEmailList> getAlertEmails({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @MultiPart()
  @POST('/api/v1/emails/alerts/')
  Future<AlertEmail> addAlertEmail({
    @Part(name: 'monitored_value') required AlertEnum monitoredValue,
    @Part(name: 'send_to_users') List<String>? sendToUsers,
    @Part(name: 'danger_point') int? dangerPoint,
    @Part(name: 'warning_point') int? warningPoint,
    @Part(name: 'danger_reminder_interval') int? dangerReminderInterval,
    @Part(name: 'warning_reminder_interval') int? warningReminderInterval,
    @Part(name: 'custom_alert_message') String? customAlertMessage,
    @Part(name: 'enabled') bool? enabled,
    @Part(name: 'send_to_roles') List<int?>? sendToRoles,
  });

  /// [id] - A unique integer value identifying this alert email.
  @GET('/api/v1/emails/alerts/{id}/')
  Future<AlertEmail> getAlertEmail({
    @Path('id') required int id,
  });

  /// [id] - A unique integer value identifying this alert email.
  @MultiPart()
  @PUT('/api/v1/emails/alerts/{id}/')
  Future<AlertEmail> updateAlertEmail({
    @Path('id') required int id,
    @Part(name: 'monitored_value') required AlertEnum monitoredValue,
    @Part(name: 'send_to_users') List<String>? sendToUsers,
    @Part(name: 'danger_point') int? dangerPoint,
    @Part(name: 'warning_point') int? warningPoint,
    @Part(name: 'danger_reminder_interval') int? dangerReminderInterval,
    @Part(name: 'warning_reminder_interval') int? warningReminderInterval,
    @Part(name: 'custom_alert_message') String? customAlertMessage,
    @Part(name: 'enabled') bool? enabled,
    @Part(name: 'send_to_roles') List<int?>? sendToRoles,
  });

  /// [id] - A unique integer value identifying this alert email.
  @MultiPart()
  @PATCH('/api/v1/emails/alerts/{id}/')
  Future<AlertEmail> partialUpdateAlertEmail({
    @Path('id') required int id,
    @Part(name: 'send_to_users') List<String>? sendToUsers,
    @Part(name: 'monitored_value') AlertEnum? monitoredValue,
    @Part(name: 'danger_point') int? dangerPoint,
    @Part(name: 'warning_point') int? warningPoint,
    @Part(name: 'danger_reminder_interval') int? dangerReminderInterval,
    @Part(name: 'warning_reminder_interval') int? warningReminderInterval,
    @Part(name: 'custom_alert_message') String? customAlertMessage,
    @Part(name: 'enabled') bool? enabled,
    @Part(name: 'send_to_roles') List<int?>? sendToRoles,
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
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/emails/schedules/')
  Future<PaginatedEmailScheduleList> getEmailSchedules({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @MultiPart()
  @POST('/api/v1/emails/schedules/')
  Future<EmailSchedule> addEmailSchedule({
    @Part(name: 'rapport') required RapportEnum rapport,
    @Part(name: 'temps_envoi') required String tempsEnvoi,
    @Part(name: 'interval') required IntervalEnum interval,
    @Part(name: 'scheduled_users') required List<String> scheduledUsers,
    @Part(name: 'interval_manual') int? intervalManual,
    @Part(name: 'next_run_time') DateTime? nextRunTime,
    @Part(name: 'scheduled_roles') List<int>? scheduledRoles,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @GET('/api/v1/emails/schedules/{id}/')
  Future<EmailSchedule> getEmailSchedule({
    @Path('id') required int id,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @MultiPart()
  @PUT('/api/v1/emails/schedules/{id}/')
  Future<EmailSchedule> updateEmailSchedule({
    @Path('id') required int id,
    @Part(name: 'rapport') required RapportEnum rapport,
    @Part(name: 'temps_envoi') required String tempsEnvoi,
    @Part(name: 'interval') required IntervalEnum interval,
    @Part(name: 'scheduled_users') required List<String> scheduledUsers,
    @Part(name: 'interval_manual') int? intervalManual,
    @Part(name: 'next_run_time') DateTime? nextRunTime,
    @Part(name: 'scheduled_roles') List<int>? scheduledRoles,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @MultiPart()
  @PATCH('/api/v1/emails/schedules/{id}/')
  Future<EmailSchedule> partialUpdateEmailSchedule({
    @Path('id') required int id,
    @Part(name: 'rapport') RapportEnum? rapport,
    @Part(name: 'temps_envoi') String? tempsEnvoi,
    @Part(name: 'interval') IntervalEnum? interval,
    @Part(name: 'interval_manual') int? intervalManual,
    @Part(name: 'next_run_time') DateTime? nextRunTime,
    @Part(name: 'scheduled_users') List<String>? scheduledUsers,
    @Part(name: 'scheduled_roles') List<int>? scheduledRoles,
  });

  /// [id] - A unique integer value identifying this email schedule.
  @DELETE('/api/v1/emails/schedules/{id}/')
  Future<void> destroyEmailSchedule({
    @Path('id') required int id,
  });

  /// [enablePagination] - Enable or disable pagination.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Number of results per page.
  @GET('/api/v1/emails/sent/')
  Future<PaginatedSentEmailList> getSentEmails({
    @Query('enable_pagination') bool? enablePagination,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
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
    @Part(name: 'color') String? color,
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
    @Part(name: 'color') String? color,
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
    @Part(name: 'color') String? color,
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

  /// Get the CA certificate
  @GET('/ca')
  Future<String> getCA();
}
