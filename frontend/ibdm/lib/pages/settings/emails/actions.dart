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
    String? monitorType,
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
    final strings = getTranslations(context);
    // add alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: strings.addingAlert,
        messageSuccess: strings.alertAdded,
        messageError: strings.failedToAddAlert,
        state: state);
    try {
      final api = await ApiClientInstance.getApiClient();
      await api.addAlertEmail(
        body: AlertEmailRequest(
          monitoredValue: AlertEnum.fromJson(monitoredValue),
          monitorType: monitorType != null
              ? MonitorTypeEnum.fromJson(monitorType)
              : null,
          dangerPoint: dangerPoint != null ? double.parse(dangerPoint) : null,
          warningPoint:
              warningPoint != null ? double.parse(warningPoint) : null,
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
      Toasts.showErrorToast(
          context: context, message: strings.failedToAddAlert);
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
    String? monitorType,
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
    final strings = getTranslations(context);
    // add alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: strings.savingAlert,
        messageSuccess: strings.alertSaved,
        messageError: strings.failedToSaveAlert,
        state: state);
    try {
      final api = await ApiClientInstance.getApiClient();
      logger.e("monitorType: $monitorType");
      await api.partialUpdateAlertEmail(
          id: alertId,
          body: PatchedAlertEmailRequest(
            monitoredValue: monitoredValue != null
                ? AlertEnum.fromJson(monitoredValue)
                : null,
            monitorType: monitorType != null
                ? MonitorTypeEnum.fromJson(monitorType)
                : null,
            dangerPoint: dangerPoint != null ? double.parse(dangerPoint) : null,
            warningPoint:
                warningPoint != null ? double.parse(warningPoint) : null,
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
      Toasts.showErrorToast(
          context: context, message: strings.failedToSaveAlert);
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
    required AlertEmail alert,
    required bool enabled,
    Function? onSuccess,
    Function? onFail,
  }) async {
    final strings = getTranslations(context);
    // enable or disable alert
    final actionStr = enabled ? strings.activating : strings.deactivating;
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      context: context,
      message: enabled ? strings.activatingAlert : strings.deactivatingAlert,
      messageSuccess:
          enabled ? strings.alertActivated : strings.alertDeactivated,
      messageError: enabled
          ? strings.failedToActivateAlert
          : strings.failedToDeactivateAlert,
      state: state,
    );
    try {
      final api = await ApiClientInstance.getApiClient();

      await api.partialUpdateAlertEmail(
          id: alert.id,
          body: PatchedAlertEmailRequest(
            customAlertMessage: alert.customAlertMessage,
            dangerPoint: alert.dangerPoint,
            dangerReminderInterval: alert.dangerReminderInterval,
            warningPoint: alert.warningPoint,
            warningReminderInterval: alert.warningReminderInterval,
            monitoredValue: alert.monitoredValue,
            monitorType: alert.monitorType,
            sendToUsers: alert.sendToUsers,
            sendToRoles: alert.sendToRoles,
            enabled: enabled,
          ));
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to $actionStr alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(
        context: context,
        message: enabled
            ? strings.failedToActivateAlert
            : strings.failedToDeactivateAlert,
      );
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
    final strings = getTranslations(context);
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      logger.e("Form is not valid");
      Toasts.showErrorToastNotification(
          context: context, message: strings.pleaseFixErrorsInTheForm);
      return;
    }
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
    final strings = getTranslations(context);
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      logger.e("Form is not valid");
      Toasts.showErrorToastNotification(
          context: context, message: strings.pleaseFixErrorsInTheForm);
      return;
    }
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
