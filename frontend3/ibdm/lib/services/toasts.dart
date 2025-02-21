import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:toastification/toastification.dart';

class Toasts {
  Toasts._();

  static ToastificationItem showLoadingToast({
    required BuildContext context,
    required String message,
  }) {
    return toastification.show(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.surfaceContainer),
      title: Center(child: Text(message)),
      alignment: Alignment.topCenter,
      icon: CircularProgressIndicator.adaptive(),
      closeButtonShowType: CloseButtonShowType.onHover,
      showProgressBar: false,
      dragToClose: true,
      style: ToastificationStyle.flat,
      showIcon: true,
    );
  }

  static ToastificationItem showErrorToast({
    required BuildContext context,
    required String message,
    ToastificationCallbacks? callbacks,
  }) {
    return toastification.show(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.surfaceContainer),
      title: Center(child: Text(message)),
      alignment: Alignment.topCenter,
      icon: Icon(Icons.close, color: errorColor),
      closeButtonShowType: CloseButtonShowType.onHover,
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: errorColor,
      ),
      dragToClose: true,
      style: ToastificationStyle.flat,
      showIcon: true,
      autoCloseDuration: Duration(seconds: 5),
      callbacks: callbacks ?? ToastificationCallbacks(),
    );
  }

  static ToastificationItem showSuccessToast({
    required BuildContext context,
    required String message,
  }) {
    return toastification.show(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.surfaceContainer),
      title: Center(child: Text(message)),
      alignment: Alignment.topCenter,
      icon: Icon(Icons.check, color: successColor),
      closeButtonShowType: CloseButtonShowType.onHover,
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: successColor,
      ),
      dragToClose: true,
      style: ToastificationStyle.flat,
      showIcon: true,
      autoCloseDuration: Duration(seconds: 5),
    );
  }

  static ElegantNotification showErrorToastNotification({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    final toast = ElegantNotification.error(
      border: Border.all(color: Theme.of(context).colorScheme.surfaceContainer),
      width: isLargeScreen(context) ? 400 : null,
      background: Theme.of(context).colorScheme.surfaceContainer,
      description: Text(message),
      title: title != null ? Text(title) : null,
      position: Alignment.bottomRight,
      animation: AnimationType.fromRight,
      toastDuration: Duration(seconds: 5),
    );
    toast.show(context);
    return toast;
  }

  static ElegantNotification showSuccessToastNotification({
    required BuildContext context,
    required String message,
    String? title,
  }) {
    final toast = ElegantNotification.success(
      border: Border.all(color: Theme.of(context).colorScheme.surfaceContainer),
      width: isLargeScreen(context) ? 400 : null,
      background: Theme.of(context).colorScheme.surfaceContainer,
      description: Text(message),
      title: title != null ? Text(title) : null,
      position: Alignment.bottomRight,
      animation: AnimationType.fromRight,
    );
    toast.show(context);
    return toast;
  }

  static ToastificationItem showStatefulToast({
    required BuildContext context,
    required String message,
    String? messageSuccess,
    String? messageError,
    required Rx<FutureState> state,
  }) {
    return toastification.show(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      borderSide:
          BorderSide(color: Theme.of(context).colorScheme.surfaceContainer),
      title: Center(child: Obx(() {
        return state.value == FutureState.loading
            ? Text(message)
            : state.value == FutureState.success
                ? Text(messageSuccess ?? message)
                : Text(messageError ?? message);
      })),
      alignment: Alignment.topCenter,
      icon: Obx(() {
        return state.value == FutureState.loading
            ? CircularProgressIndicator.adaptive()
            : state.value == FutureState.success
                ? Icon(Icons.check, color: successColor)
                : Icon(Icons.close, color: errorColor);
      }),
      closeButtonShowType: CloseButtonShowType.onHover,
      showProgressBar: false,
      dragToClose: true,
      style: ToastificationStyle.flat,
      showIcon: true,
    );
  }
}
