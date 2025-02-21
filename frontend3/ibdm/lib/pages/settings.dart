import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/responsive_appbar.dart';
import 'package:ibdm/utils/constants/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: ResponsiveAppBar(
        userName: userController.user?.name ?? "Invité",
        userImage: (userController.user?.avatarUrl != null &&
                userController.user!.avatarUrl!.isNotEmpty)
            ? userController.user!.avatarUrl!
            : '',
        onLogout: () {
          userController.logoutUser();
          Get.offAllNamed(Routes.login);
        },
      ),
      body: AppCustomContainer(
        child: Center(
          child: Text("Page: Settings"),
        ),
      ),
    );
  }
}
