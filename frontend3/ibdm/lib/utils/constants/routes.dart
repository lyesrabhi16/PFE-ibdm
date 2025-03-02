import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/middlewares/require_un_authenticated_route_middleware.dart';
import 'package:ibdm/pages/filtration.dart/filtration.dart';
import 'package:ibdm/pages/AboutPage.dart';
import 'package:ibdm/pages/home.dart';
import 'package:ibdm/pages/login/login_page.dart';
import 'package:ibdm/common/middlewares/protected_route_middleware.dart';
import 'package:ibdm/pages/settings.dart';
import 'package:ibdm/pages/siroperie/siroperie.dart';
import 'package:ibdm/pages/users.dart';
import 'package:ibdm/pages/EmailSettingsPage.dart';
import 'package:ibdm/pages/HelpPage.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Routes {
  Routes._();

  static final UserController userController = Get.find<UserController>();

  static const String home = '/';
  static const String login = '/login';
  static const String siroperie = '/siroperie';
  static const String filtration = '/filtration';
  static const String settings = '/settings';
  static const String users = '/users';
  static const String emailSettings = '/settings/emailsettings';
  static const String about = '/settings/about';
  static const String help = '/settings/help';

  static List<Destination> get destinations => [
        Destination(
          title: "Home",
          icon: Icons.home,
          route: Routes.home,
          page: routePages[Routes.home]!,
        ),
        Destination(
          title: "Users",
          icon: Icons.people,
          route: Routes.users,
          page: routePages[Routes.users]!,
        ).withPermission(Permissions.viewUsersPage),
        Destination(
          title: "Siroperie",
          icon: LucideIcons.boxes,
          route: Routes.siroperie,
          page: routePages[Routes.siroperie]!,
        ).withPermission(Permissions.viewSiroperiePage),
        Destination(
          title: "Filtration",
          icon: Icons.battery_full_outlined,
          route: Routes.filtration,
          page: routePages[Routes.filtration]!,
        ).withPermission(Permissions.viewFiltrationPage),
        Destination(
          title: "Settings",
          icon: Icons.settings,
          route: Routes.settings,
          page: routePages[Routes.settings]!,
        ).withPermission(Permissions.viewSettingsPage),
      ].nonNulls.toList();

  static final customRoutes = {
    emailSettings: settings,
    about: settings,
    help: settings,
  };

  static final routePages = {
    Routes.home: GetPage(
      name: Routes.home,
      page: () => Home(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    Routes.login: GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      middlewares: [RequireUnAuthenticatedRouteMiddleware()],
    ),
    Routes.emailSettings: GetPage(
      name: emailSettings,
      page: () => EmailSettingsPage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    Routes.about: GetPage(
        name: about,
        page: () => Aboutpage(),
        middlewares: [ProtectedRouteMiddleware()]),
    Routes.help: GetPage(
        name: help,
        page: () => Helppage(),
        middlewares: [ProtectedRouteMiddleware()]),
    Routes.siroperie: GetPage(
      name: Routes.siroperie,
      page: () => SiroperiePage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    Routes.filtration: GetPage(
      name: Routes.filtration,
      page: () => FiltrationPage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    Routes.settings: GetPage(
      name: Routes.settings,
      page: () => SettingsPage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
    Routes.users: GetPage(
      name: Routes.users,
      page: () => UsersPage(),
      middlewares: [ProtectedRouteMiddleware()],
    ),
  };

  static List<GetPage> router = routePages.values.toList();
}
