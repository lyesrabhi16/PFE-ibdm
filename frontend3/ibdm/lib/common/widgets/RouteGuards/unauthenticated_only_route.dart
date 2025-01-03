import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/routes.dart';

class UnauthenticatedOnlyRoute extends StatelessWidget {
  UnauthenticatedOnlyRoute({
    super.key,
    required this.child,
    this.redirectRoute = Routes.home,
    this.message,
  });

  final Widget child;
  final UserController userController = Get.find<UserController>();
  final String redirectRoute;
  final String? message;

  @override
  Widget build(BuildContext context) {
    if (!userController.isAuthenticated) {
      return child;
    } else {
      Future.delayed(Duration.zero, () {
        Get.toNamed(Routes.home);
      });

      if (message != null) {
        Toasts.showErrorToast(context: context, message: message!);
      }
    }
    return Center(child: CircularProgressIndicator());
  }
}
