import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/drawer_container.dart';
import 'package:ibdm/common/widgets/responsive_appbar.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/pages/loading_page.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';

class AppCustomContainer extends StatelessWidget {
  const AppCustomContainer(
      {super.key, required this.child, this.backButton = false});
  final Widget child;
  final bool backButton;
  static final userController = Get.find<UserController>();

  _checkPermissions() {
    final permissionsController = Get.find<PermissionsController>();

    if (permissionsController.ready.value == false) {
      throw ("permissions not ready in _checkPermission of AppCustomContainer");
    }

    final RoutePermissions = Routes.routePermissions[Get.currentRoute];
    if (RoutePermissions != null) {
      if (!RoutePermissions.checkPermissions()) {
        Get.offAllNamed(Routes.noPermissions);
      }
    } else {
      throw ("RoutePermissions not found in _checkPermission of AppCustomContainer");
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final loadingPageController = Get.find<LoadingPageController>();

    return Obx(() {
      if (loadingPageController.isLoading.value) {
        return LoadingPage();
      }

      _checkPermissions();

      _getBackRoute() {
        final _urlParts = Get.currentRoute.split("/");
        if (_urlParts.length > 2) {
          return _urlParts.sublist(0, _urlParts.length - 1).join("/");
        }
        return null;
      }

      final _backRoute = _getBackRoute();

      final _child = Container(
        child: Column(
          children: [
            if (_backRoute != null)
              Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Get.toNamed(_backRoute);
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: (() => child)(),
            ),
          ],
        ),
      );

      return SafeArea(
        child: Scaffold(
          appBar: ResponsiveAppBar(
            userName: userController.user?.username ?? strings.value.noName,
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
              ? DrawerContainer(child: _child)
              : SideMenuContainer(child: _child),
        ),
      );
    });
  }
}
