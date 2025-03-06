import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:toastification/toastification.dart';

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
      final res = await api.addAlertEmail(
        monitoredValue: AlertEnum.fromJson(monitoredValue),
        dangerPoint: dangerPoint != null ? int.parse(dangerPoint) : null,
        warningPoint: warningPoint != null ? int.parse(warningPoint) : null,
        dangerReminderInterval:
            dangerAlertInterval != null ? int.parse(dangerAlertInterval) : null,
        warningReminderInterval: warningAlertInterval != null
            ? int.parse(warningAlertInterval)
            : null,
        customAlertMessage: customMessage,
        enabled: enabled,
        sendToUsers: users?.map((e) => e.email).toList(),
        sendToRoles: roles?.map((e) => e.roleId).toList(),
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

      final res = await api.partialUpdateAlertEmail(
        id: alertId,
        monitoredValue:
            monitoredValue != null ? AlertEnum.fromJson(monitoredValue) : null,
        dangerPoint: dangerPoint != null ? int.parse(dangerPoint) : null,
        warningPoint: warningPoint != null ? int.parse(warningPoint) : null,
        dangerReminderInterval:
            dangerAlertInterval != null ? int.parse(dangerAlertInterval) : null,
        warningReminderInterval: warningAlertInterval != null
            ? int.parse(warningAlertInterval)
            : null,
        customAlertMessage: customMessage,
        enabled: enabled,
        sendToUsers: users?.map((e) => e.email).toList(),
        sendToRoles: roles?.map((e) => e.roleId).toList(),
      );
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
        enabled: enabled,
      );
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
}
