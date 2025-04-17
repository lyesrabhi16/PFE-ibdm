import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controller.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/utils/constants/route_permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';

class ProtectedRouteMiddleware extends GetMiddleware {
  static final UserController userController = Get.find<UserController>();
  static final PermissionsController permissionsController =
      Get.find<PermissionsController>();
  RoutePermissions? routePermissions;
  bool bypass = false;

  ProtectedRouteMiddleware({super.priority, this.routePermissions});
  @override
  RouteSettings? redirect(String? route) {
    if (bypass && !kReleaseMode) {
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
