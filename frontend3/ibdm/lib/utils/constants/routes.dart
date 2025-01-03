import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/RouteGuards/protected_route.dart';
import 'package:ibdm/common/widgets/RouteGuards/unauthenticated_only_route.dart';
import 'package:ibdm/pages/home.dart';
import 'package:ibdm/pages/login/login_page.dart';

class Routes {
  Routes._();

  static const String home = '/';
  static const String login = '/login';

  static final router = [
    GetPage(
      name: Routes.home,
      page: () => ProtectedRoute(
        message: "You need to login to access this page",
        child: Home(),
      ),
    ),
    GetPage(
      name: Routes.login,
      page: () => UnauthenticatedOnlyRoute(
          message: "You are already logged in", child: LoginPage()),
    ),
    GetPage(
      name: "/protected",
      page: () => ProtectedRoute(
        message: "You need to login to access this page",
        child: Center(
          child: Text("This Should Be Protected"),
        ),
      ),
    ),
  ];
}
