import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/middlewares/require_un_authenticated_route_middleware.dart';
import 'package:ibdm/pages/co2/co2.dart';
import 'package:ibdm/pages/filtration.dart/filtration.dart';
import 'package:ibdm/pages/no_permissions.dart';
import 'package:ibdm/pages/not_found.dart';
import 'package:ibdm/pages/server-status/server_status.dart';
import 'package:ibdm/pages/settings/about_page.dart';
import 'package:ibdm/pages/home.dart';
import 'package:ibdm/pages/login/login_page.dart';
import 'package:ibdm/common/middlewares/protected_route_middleware.dart';
import 'package:ibdm/pages/settings/emails/email_alerts_page.dart';
import 'package:ibdm/pages/settings/emails/email_schedules_page.dart';
import 'package:ibdm/pages/settings/server_settings/server_settings.dart';
import 'package:ibdm/pages/settings/settings.dart';
import 'package:ibdm/pages/siroperie/siroperie.dart';
import 'package:ibdm/pages/users.dart';
import 'package:ibdm/pages/settings/emails/email_settings_page.dart';
import 'package:ibdm/pages/settings/emails/email_sents_page.dart';
import 'package:ibdm/pages/settings/help_page.dart';
import 'package:ibdm/pages/utilite/utilite.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/constants/route_permissions.dart';
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
  static const String emailSettings = '/settings/email-settings';
  static const String emailSchedules = '/settings/email-settings/schedules';
  static const String emailAlerts = '/settings/email-settings/alerts';
  static const String emailSent = '/settings/email-settings/sent';
  static const String about = '/settings/about';
  static const String help = '/settings/help';
  static const String utilite = '/utilite';
  static const String co2 = '/co2';
  static const String serverStatus = "/server-status";
  static const String serverSettings = "/settings/server";
  static const String noPermissions = "/no-permissions";
  static const String notFound = "/404";

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
          title: "Utilité",
          icon: LucideIcons.gauge,
          route: Routes.utilite,
          page: routePages[Routes.utilite]!,
        ).withPermission(Permissions.viewUtilitePage),
        Destination(
          title: "CO2",
          icon: LucideIcons.cloud,
          route: Routes.co2,
          page: routePages[Routes.co2]!,
        ).withPermission(Permissions.viewCo2Page),
        Destination(
          title: "Server Status",
          icon: LucideIcons.server,
          route: Routes.serverStatus,
          page: routePages[Routes.serverStatus]!,
        ).withPermission(Permissions.viewServerStatusPage),
        Destination(
          title: "Settings",
          icon: Icons.settings,
          route: Routes.settings,
          page: routePages[Routes.settings]!,
        ).withPermission(Permissions.viewSettingsPage),
      ].nonNulls.toList();

  static final customRoutes = {
    serverSettings: Routes.serverSettings,
    emailSettings: settings,
    emailSchedules: settings,
    emailAlerts: settings,
    emailSent: settings,
    about: settings,
    help: settings,
  };
  static final routePermissions = {
    Routes.home: RoutePermissions(),
    Routes.login: RoutePermissions(),
    Routes.emailSettings: RoutePermissions(
      anyOfPermissions: [
        Permissions.viewEmailAlerts,
        Permissions.viewEmailSchedules,
        Permissions.viewEmailsSent,
      ],
    ),
    Routes.emailSchedules: RoutePermissions(
      requiredPermissions: [Permissions.viewEmailSchedules],
    ),
    Routes.emailAlerts: RoutePermissions(
      requiredPermissions: [Permissions.viewEmailAlerts],
    ),
    Routes.emailSent: RoutePermissions(
      requiredPermissions: [Permissions.viewEmailsSent],
    ),
    Routes.about: RoutePermissions(),
    Routes.help: RoutePermissions(),
    Routes.siroperie: RoutePermissions(
      requiredPermissions: [Permissions.viewSiroperiePage],
    ),
    Routes.filtration: RoutePermissions(
      requiredPermissions: [Permissions.viewFiltrationPage],
    ),
    Routes.settings: RoutePermissions(
      requiredPermissions: [Permissions.viewSettingsPage],
    ),
    Routes.users: RoutePermissions(
      requiredPermissions: [Permissions.viewUsersPage],
    ),
    Routes.notFound: RoutePermissions(),
    Routes.noPermissions: RoutePermissions(),
    Routes.utilite: RoutePermissions(
      requiredPermissions: [Permissions.viewUtilitePage],
    ),
    Routes.co2: RoutePermissions(
      requiredPermissions: [Permissions.viewCo2Page],
    ),
    Routes.serverStatus: RoutePermissions(
      requiredPermissions: [Permissions.viewServerStatusPage],
    ),
    Routes.serverSettings: RoutePermissions(
      requiredPermissions: [Permissions.viewServerSettingsPage],
    ),
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
      middlewares: [
        ProtectedRouteMiddleware(
            routePermissions: routePermissions[emailSettings])
      ],
    ),
    Routes.emailSchedules: GetPage(
      name: emailSchedules,
      page: () => EmailSchedulesPage(),
      middlewares: [
        ProtectedRouteMiddleware(
            routePermissions: routePermissions[emailSchedules])
      ],
    ),
    Routes.emailAlerts: GetPage(
      name: emailAlerts,
      page: () => EmailAlertsPage(),
      middlewares: [
        ProtectedRouteMiddleware(
            routePermissions: routePermissions[emailAlerts])
      ],
    ),
    Routes.emailSent: GetPage(
      name: emailSent,
      page: () => EmailSentsPage(),
      middlewares: [
        ProtectedRouteMiddleware(routePermissions: routePermissions[emailSent])
      ],
    ),
    Routes.about: GetPage(name: about, page: () => AboutPage(), middlewares: [
      ProtectedRouteMiddleware(
        routePermissions: routePermissions[about],
      )
    ]),
    Routes.help: GetPage(name: help, page: () => HelpPage(), middlewares: [
      ProtectedRouteMiddleware(
        routePermissions: routePermissions[help],
      )
    ]),
    Routes.siroperie: GetPage(
      name: Routes.siroperie,
      page: () => SiroperiePage(),
      middlewares: [
        ProtectedRouteMiddleware(
          routePermissions: routePermissions[Routes.siroperie],
        )
      ],
    ),
    Routes.serverStatus: GetPage(
      name: Routes.serverStatus,
      page: () => ServerStatusPage(),
      middlewares: [
        ProtectedRouteMiddleware(
          routePermissions: routePermissions[Routes.serverStatus],
        )
      ],
    ),
    Routes.serverSettings: GetPage(
      name: Routes.serverSettings,
      page: () => ServerSettingsPage(),
      middlewares: [
        ProtectedRouteMiddleware(
          routePermissions: routePermissions[Routes.serverSettings],
        )
      ],
    ),
    Routes.filtration: GetPage(
      name: Routes.filtration,
      page: () => FiltrationPage(),
      middlewares: [
        ProtectedRouteMiddleware(
          routePermissions: routePermissions[Routes.filtration],
        )
      ],
    ),
    Routes.settings: GetPage(
      name: Routes.settings,
      page: () => SettingsPage(),
      middlewares: [
        ProtectedRouteMiddleware(
            routePermissions: routePermissions[Routes.settings])
      ],
    ),
    Routes.users: GetPage(
      name: Routes.users,
      page: () => UsersPage(),
      middlewares: [
        ProtectedRouteMiddleware(
            routePermissions: routePermissions[Routes.users])
      ],
    ),
    Routes.utilite: GetPage(
      name: Routes.utilite,
      page: () => UtilitePage(),
      middlewares: [
        ProtectedRouteMiddleware(
            routePermissions: routePermissions[Routes.utilite])
      ],
    ),
    Routes.co2: GetPage(
      name: Routes.co2,
      page: () => CO2Page(),
      middlewares: [
        ProtectedRouteMiddleware(routePermissions: routePermissions[Routes.co2])
      ],
    ),
    Routes.noPermissions: GetPage(
        name: Routes.noPermissions,
        page: () => NoPermissionsPage(),
        middlewares: [
          ProtectedRouteMiddleware(
              routePermissions: routePermissions[Routes.noPermissions])
        ]),
    Routes.notFound: GetPage(
      name: Routes.notFound,
      page: () => NotFoundPage(),
    ),
  };

  static List<GetPage> router = routePages.values.toList();
}
