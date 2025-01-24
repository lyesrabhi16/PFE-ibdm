import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/middlewares/require_un_authenticated_route_middleware.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/pages/home.dart';
import 'package:ibdm/pages/login/login_page.dart';
import 'package:ibdm/common/middlewares/protected_route_middleware.dart';
import 'package:ibdm/pages/settings.dart';
import 'package:ibdm/pages/users.dart';

class Routes {
  Routes._();

  static const String home = '/';
  static const String login = '/login';
  static const String settings = '/settings';
  static const String users = '/users';

  static final router = [
    GetPage(
      name: Routes.home,
      page: () => Home(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      middlewares: [RequireUnAuthenticatedRouteMiddleware()],
    ),
    GetPage(
      name: Routes.users,
      page: () => UsersPage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    GetPage(
      name: Routes.settings,
      page: () => SettingsPage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    GetPage(
      name: "/protected",
      middlewares: [ProtectedRouteMiddleware()],
      page: () => AppCustomContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Protected Route"),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.home);
              },
              child: Text("Home"),
            )
          ],
        ),
      ),
    ),
  ];
}
