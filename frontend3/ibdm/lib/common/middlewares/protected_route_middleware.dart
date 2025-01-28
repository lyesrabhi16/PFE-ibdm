import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/utils/constants/routes.dart';

class ProtectedRouteMiddleware extends GetMiddleware {
  static final UserController userController = Get.find<UserController>();
  @override
  RouteSettings? redirect(String? route) {
    if (userController.isAuthenticated) {
      return null;
    }
    return RouteSettings(name: Routes.login);
  }
}
