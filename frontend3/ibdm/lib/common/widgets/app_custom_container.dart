import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/drawer_container.dart';
import 'package:ibdm/common/widgets/responsive_appbar.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/helpers/screen.dart';

class AppCustomContainer extends StatelessWidget {
  const AppCustomContainer({super.key, required this.child});
  final Widget child;
  static final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ResponsiveAppBar(
          userName: userController.user?.username ?? "No Name",
          userImage: (userController.user?.avatarUrl != null &&
                  userController.user!.avatarUrl!.isNotEmpty)
              ? userController.user!.avatarUrl!
              : '',
          onLogout: () {
            userController.logoutUser();
            Get.offAllNamed(Routes.login);
          },
        ),
        body: isAtMostSmallScreen(context)
            ? DrawerContainer(child: child)
            : SideMenuContainer(child: child),
      ),
    );
  }
}
