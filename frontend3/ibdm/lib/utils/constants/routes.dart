import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/middlewares/require_un_authenticated_route_middleware.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/pages/home.dart';
import 'package:ibdm/pages/login/login_page.dart';
import 'package:ibdm/common/middlewares/protected_route_middleware.dart';
import 'package:ibdm/pages/settings.dart';
import 'package:ibdm/pages/users.dart';
import 'package:ibdm/utils/constants/destinations.dart';

class Routes {
  Routes._();

  static final UserController userController = Get.find<UserController>();

  static const String home = '/';
  static const String login = '/login';
  static const String settings = '/settings';
  static const String users = '/users';

  static List<Destination> get destinations => [
        Destination(
          title: "Home",
          icon: Icons.home,
          route: Routes.home,
          page: GetPage(
            name: Routes.home,
            page: () => Home(),
            middlewares: [ProtectedRouteMiddleware()],
          ),
        ),
        Destination(
          title: "Protected",
          icon: Icons.lock,
          route: "/protected",
          page: GetPage(
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
        ),
        Destination(
          title: "Users",
          icon: Icons.people,
          route: Routes.users,
          page: GetPage(
            name: Routes.users,
            page: () => UsersPage(),
            middlewares: [ProtectedRouteMiddleware()],
          ),
        ),
        Destination(
          title: "Settings",
          icon: Icons.settings,
          route: Routes.settings,
          page: GetPage(
            name: Routes.settings,
            page: () => SettingsPage(),
            middlewares: [ProtectedRouteMiddleware()],
          ),
        ),
      ].nonNulls.toList();

  static final List<GetPage> routesWithoutNavigation = [
    GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      middlewares: [RequireUnAuthenticatedRouteMiddleware()],
    ),
  ].nonNulls.toList();

  static List<GetPage> get router => [
        ...routesWithoutNavigation,
        ...destinations.map((e) => e.page),
      ].nonNulls.toList();
}
