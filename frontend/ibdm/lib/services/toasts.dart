import 'package:auto_size_text/auto_size_text.dart';
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
      title: Center(child: SizedBox(height: 25, child: AutoSizeText(message))),
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
      title: Center(child: SizedBox(height: 25, child: AutoSizeText(message))),
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
      title: Center(child: SizedBox(height: 25, child: AutoSizeText(message))),
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
      width: 300,
      background: Theme.of(context).colorScheme.surfaceContainer,
      description: SizedBox(
        height: 50,
        child: AutoSizeText(
          message,
        ),
      ),
      title: title != null
          ? SizedBox(height: 25, child: AutoSizeText(title))
          : null,
      position: Alignment.bottomRight,
      animation: AnimationType.fromRight,
      toastDuration: Duration(seconds: 5),
    );
    toast.show(context);
    return toast;
  }

  static ElegantNotification showInfoToastNotification({
    required BuildContext context,
    required String message,
    String? title,
    bool autoDismiss = true,
  }) {
    final toast = ElegantNotification.info(
      border: Border.all(color: Theme.of(context).colorScheme.surfaceContainer),
      width: 300,
      background: Theme.of(context).colorScheme.surfaceContainer,
      description: SizedBox(height: 50, child: AutoSizeText(message)),
      title: title != null
          ? SizedBox(height: 25, child: AutoSizeText(title))
          : null,
      position: Alignment.bottomRight,
      animation: AnimationType.fromRight,
      showProgressIndicator: false,
      autoDismiss: autoDismiss,
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
      width: 300,
      background: Theme.of(context).colorScheme.surfaceContainer,
      description: SizedBox(height: 50, child: AutoSizeText(message)),
      title: title != null
          ? SizedBox(height: 25, child: AutoSizeText(title))
          : null,
      position: Alignment.bottomRight,
      animation: AnimationType.fromRight,
      dismissDirection: DismissDirection.down,
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
            ? SizedBox(height: 25, child: AutoSizeText(message))
            : state.value == FutureState.success
                ? SizedBox(
                    height: 25, child: AutoSizeText(messageSuccess ?? message))
                : SizedBox(
                    height: 25, child: AutoSizeText(messageError ?? message));
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
