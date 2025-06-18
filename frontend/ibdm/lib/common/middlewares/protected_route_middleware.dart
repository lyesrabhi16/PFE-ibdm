import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/bypass_controller.dart';
import 'package:ibdm/common/controllers/permissions_controller.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/utils/constants/route_permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class ProtectedRouteMiddleware extends GetMiddleware {
  static final UserController userController = Get.find<UserController>();
  static final PermissionsController permissionsController =
      Get.find<PermissionsController>();
  RoutePermissions? routePermissions;
  bool bypass = BypassController.bypass;

  ProtectedRouteMiddleware({super.priority, this.routePermissions});
  @override
  RouteSettings? redirect(String? route) {
    if (bypass && !kReleaseMode) {
      return null;
    }
    logger.d(
        "ProtectedRouteMiddleware: Checking route: $route, user controller initialized: ${userController.initialized}, permissions ready: ${permissionsController.ready.value}, bypass: $bypass");
    if (userController.isReady.value == false) {
      logger.d("await UserController initialization");
      userController.isReady.listen((isReady) {
        if (isReady) {
          logger.d("UserController is ready, redirecting to $route");
          Get.offAllNamed(route ?? Routes.home);
        }
      });
      return null;
    }
    if (!userController.isAuthenticated) {
      return RouteSettings(name: Routes.login);
    }
    if (permissionsController.ready.value == false) {
      return null;
    }
    if (routePermissions != null) {
      if (!routePermissions!.checkPermissions()) {
        return RouteSettings(name: Routes.noPermissions);
      }
    }
    return null;
  }
}
