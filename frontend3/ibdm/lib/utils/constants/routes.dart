import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/middlewares/require_un_authenticated_route_middleware.dart';
import 'package:ibdm/pages/home.dart';
import 'package:ibdm/pages/login/login_page.dart';
import 'package:ibdm/common/middlewares/protected_route_middleware.dart';

class Routes {
  Routes._();

  static const String home = '/';
  static const String login = '/login';

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
      name: "/protected",
      middlewares: [ProtectedRouteMiddleware()],
      page: () => Column(
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
  ];
}
