import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class RequireUnAuthenticatedRouteMiddleware extends GetMiddleware {
  static final UserController userController = Get.find<UserController>();
  @override
  GetPage? onPageCalled(GetPage? page) {
    final strings = getTranslations(Get.context!);
    if (userController.isAuthenticated) {
      Toasts.showErrorToastNotification(
        context: Get.overlayContext!,
        message: strings.logoutRequired,
        title: strings.accessDenied,
      );
      return null;
    }
    return page;
  }
}
