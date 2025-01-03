import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/routes.dart';

class ProtectedRoute extends StatelessWidget {
  ProtectedRoute(
      {super.key,
      required this.child,
      this.redirectRoute = Routes.login,
      this.message});

  final UserController userController = Get.find<UserController>();
  final Widget child;
  final String redirectRoute;
  final String? message;

  @override
  Widget build(BuildContext context) {
    if (userController.isAuthenticated) {
      return child;
    } else {
      Future.delayed(Duration.zero, () {
        Get.toNamed(redirectRoute);
      });
      if (message != null) {
        Toasts.showErrorToast(context: context, message: message!);
      }
    }
    return Center(child: CircularProgressIndicator());
  }
}
