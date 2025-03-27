import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/models/login_request_request.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:dio/dio.dart';
import 'package:toastification/toastification.dart';

class LoginActions {
  LoginActions._();
  static void login({
    required BuildContext context,
    required GlobalKey<FormState> loginFormKey,
    required Rx<FutureState> loginProgress,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool rememberMe,
  }) async {
    final strings = getTranslations(context);
    // validate form
    if (!loginFormKey.currentState!.validate()) {
      Toasts.showErrorToastNotification(
        context: context,
        message: strings.pleaseFillInAllFields,
      );
      return;
    }

    // set login progress to loading
    loginProgress.value = FutureState.loading;
    // show loading toast
    final loginInProgressToast = Toasts.showStatefulToast(
      context: context,
      message: strings.logginIn,
      messageSuccess: strings.loginSuccessful,
      messageError: strings.loginFailed,
      state: loginProgress,
    );

    // make api request
    try {
      logger.d("Creating Api Client...");
      logger.d("Requesting Login...");

      final apiClient = await ApiClientInstance.getApiClient();
      final response = await apiClient.login(
        body: LoginRequestRequest(
          email: emailController.text,
          password: passwordController.text,
          rememberMe: rememberMe,
        ),
      );
      logger.d("Login Response: $response");
      // set login progress to success
      loginProgress.value = FutureState.success;
      // close toast after delay
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismiss(loginInProgressToast);
      });
      // save user
      UserController userController = Get.find<UserController>();
      userController.setUser(response.user);

      // show success toast
      if (Get.overlayContext != null && Get.overlayContext!.mounted) {
        Toasts.showSuccessToastNotification(
          //? normal context or Get.context causes null check error
          context: Get.overlayContext!,
          message: strings.loginSuccessMessage,
          title: strings.loginSuccessful,
        );
      }

      LoadingPageController loadingPageController =
          Get.find<LoadingPageController>();
      loadingPageController.isLoading.value = true;
      PermissionsController permissionsController =
          Get.find<PermissionsController>();
      permissionsController.ready.value = false;

      logger.e(
          "Loading page is ${loadingPageController.isLoading.value} after login");

      // go to home page for now
      Get.offAllNamed(Routes.home);
    } catch (e) {
      // set login progress to error
      loginProgress.value = FutureState.error;
      // close toast after delay
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismiss(loginInProgressToast);
      });

      if (e is DioException) {
        printMessage("Login Failed: ${e.message}");
        logger.e("Login Failed: ${e.message}", error: e);

        // show error toast
        // error toast message
        String errorToastMessage;
        switch (e.type) {
          case DioExceptionType.connectionError:
            errorToastMessage = strings.connectionFailedError;
            break;
          case DioExceptionType.receiveTimeout:
            errorToastMessage = strings.timeOutError;
            break;
          case DioExceptionType.cancel:
            errorToastMessage = strings.cancelMessage;
            break;
          default:
            errorToastMessage = strings.unknownError;
        }

        if (e.response != null) {
          errorToastMessage = e.response?.data['message'];
        }
        if (context.mounted) {
          Toasts.showErrorToastNotification(
              context: context,
              message: errorToastMessage,
              title: strings.loginFailed);
        }
      } else {
        printMessage("Login Failed uncaught exception: $e");
        logger.f("Login Failed uncaught exception: $e");

        // show uncaught error toast
        if (context.mounted) {
          Toasts.showErrorToastNotification(
              context: context,
              message: strings.unknownError,
              title: strings.connectionFailed);
        }
      }
    }
  }
}
