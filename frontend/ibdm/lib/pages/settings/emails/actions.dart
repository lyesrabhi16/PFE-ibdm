import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class EmailActions {
  EmailActions._();
  static Future<void> addAlert(
    BuildContext context, {
    required String monitoredValue,
    String? customMessage,
    String? dangerAlertInterval,
    String? dangerPoint,
    bool? enabled,
    List<Role>? roles,
    List<User>? users,
    String? warningAlertInterval,
    String? warningPoint,
    Function? onSuccess,
    Function? onFail,
    GlobalKey<FormState>? formKey,
  }) async {
    // add alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: "Adding Alert...",
        messageSuccess: "Alert Added",
        messageError: "Failed to add alert",
        state: state);
    try {
      final api = await ApiClientInstance.getApiClient();
      await api.addAlertEmail(
        body: AlertEmailRequest(
          monitoredValue: AlertEnum.fromJson(monitoredValue),
          dangerPoint: dangerPoint != null ? int.parse(dangerPoint) : null,
          warningPoint: warningPoint != null ? int.parse(warningPoint) : null,
          dangerReminderInterval: dangerAlertInterval != null
              ? int.parse(dangerAlertInterval)
              : null,
          warningReminderInterval: warningAlertInterval != null
              ? int.parse(warningAlertInterval)
              : null,
          customAlertMessage: customMessage,
          enabled: enabled,
          sendToUsers: users?.map((e) => e.email).toList(),
          sendToRoles: roles?.map((e) => e.roleId).toList(),
        ),
      );
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to add alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(context: context, message: "Failed to add alert");
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }

  static Future<void> saveAlert(
    BuildContext context, {
    required int alertId,
    String? monitoredValue,
    String? customMessage,
    String? dangerAlertInterval,
    String? dangerPoint,
    bool? enabled,
    List<Role>? roles,
    List<User>? users,
    String? warningAlertInterval,
    String? warningPoint,
    Function? onSuccess,
    Function? onFail,
    GlobalKey<FormState>? formKey,
  }) async {
    // add alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: "Saving Alert...",
        messageSuccess: "Alert Saved",
        messageError: "Failed to save alert",
        state: state);
    try {
      final api = await ApiClientInstance.getApiClient();

      await api.partialUpdateAlertEmail(
          id: alertId,
          body: PatchedAlertEmailRequest(
            monitoredValue: monitoredValue != null
                ? AlertEnum.fromJson(monitoredValue)
                : null,
            dangerPoint: dangerPoint != null ? int.parse(dangerPoint) : null,
            warningPoint: warningPoint != null ? int.parse(warningPoint) : null,
            dangerReminderInterval: dangerAlertInterval != null
                ? int.parse(dangerAlertInterval)
                : null,
            warningReminderInterval: warningAlertInterval != null
                ? int.parse(warningAlertInterval)
                : null,
            customAlertMessage: customMessage,
            enabled: enabled,
            sendToUsers: users?.map((e) => e.email).toList(),
            sendToRoles: roles?.map((e) => e.roleId).toList(),
          ));
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to save alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(context: context, message: "Failed to save alert");
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }

  static Future<void> changeAlertEnabledState(
    BuildContext context, {
    required int alertId,
    required bool enabled,
    Function? onSuccess,
    Function? onFail,
  }) async {
    // enable or disable alert
    final actionStr = enabled ? 'Activating' : 'Deactivating';
    final actionDoneStr = enabled ? 'Activated' : 'Deactivated';
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      context: context,
      message: "$actionStr Alert...",
      messageSuccess: "Alert $actionDoneStr",
      messageError: "Failed to $actionDoneStr alert",
      state: state,
    );
    try {
      final api = await ApiClientInstance.getApiClient();

      await api.partialUpdateAlertEmail(
          id: alertId,
          body: PatchedAlertEmailRequest(
            enabled: enabled,
          ));
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to $actionStr alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(
          context: context, message: "Failed to $actionStr alert");
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }

  static addSchedule(
    BuildContext context, {
    required RapportEnum rapport,
    required String tempsEnvoi,
    required IntervalEnum interval,
    int? intervalManual,
    List<String>? scheduledUsers,
    List<int>? scheduledRoles,
    DateTime? nextRunTime,
    Function? onSuccess,
    Function? onFail,
    GlobalKey<FormState>? formKey,
  }) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      logger.e("Form is not valid");
      Toasts.showErrorToastNotification(
          context: context, message: "¨Please fix the errors in the form");
      return;
    }
    final strings = getTranslations(context);
    // enable or disable alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      context: context,
      message: strings.addingSchedule,
      messageSuccess: strings.scheduleAdded,
      messageError: strings.failedToAddSchedule,
      state: state,
    );
    try {
      final api = await ApiClientInstance.getApiClient();

      await api.addEmailSchedule(
        body: EmailScheduleRequest(
          rapport: rapport,
          tempsEnvoi: tempsEnvoi,
          interval: interval,
          intervalManual: intervalManual,
          nextRunTime: nextRunTime,
          scheduledUsers: scheduledUsers != null && scheduledUsers.isNotEmpty
              ? scheduledUsers
              : [],
          scheduledRoles: scheduledRoles != null && scheduledRoles.isNotEmpty
              ? scheduledRoles
              : [],
        ),
      );
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to add email schedule : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(
          context: context, message: strings.failedToAddSchedule);
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }

  static saveSchedule(
    BuildContext context, {
    required int id,
    required RapportEnum rapport,
    required String tempsEnvoi,
    required IntervalEnum interval,
    int? intervalManual,
    List<String>? scheduledUsers,
    List<int>? scheduledRoles,
    DateTime? nextRunTime,
    Function? onSuccess,
    Function? onFail,
    GlobalKey<FormState>? formKey,
  }) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      logger.e("Form is not valid");
      Toasts.showErrorToastNotification(
          context: context, message: "¨Please fix the errors in the form");
      return;
    }
    final strings = getTranslations(context);
    // enable or disable alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      context: context,
      message: strings.savingSchedule,
      messageSuccess: strings.scheduleSaved,
      messageError: strings.failedToSaveSchedule,
      state: state,
    );
    try {
      final api = await ApiClientInstance.getApiClient();
      logger.e("nextRunTime: ${nextRunTime}");
      await api.partialUpdateEmailSchedule(
        body: PatchedEmailScheduleRequest(
          rapport: rapport,
          tempsEnvoi: tempsEnvoi,
          interval: interval,
          intervalManual: intervalManual,
          nextRunTime: nextRunTime,
          scheduledUsers: scheduledUsers != null && scheduledUsers.isNotEmpty
              ? scheduledUsers
              : [],
          scheduledRoles: scheduledRoles != null && scheduledRoles.isNotEmpty
              ? scheduledRoles
              : [],
        ),
        id: id,
      );
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to save email schedule : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(
          context: context, message: strings.failedToSaveSchedule);
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }
}
