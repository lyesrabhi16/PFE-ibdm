import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/common/controllers/permissions_controller.dart';
import 'package:ibdm/common/controllers/routes_controller.dart';
import 'package:ibdm/common/controllers/side_menu_state_controller.dart';
import 'package:ibdm/common/controllers/theme_mode_controller.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/initial_binding.dart';
import 'package:ibdm/pages/co2/co2.dart';
import 'package:ibdm/pages/filtration/filtration.dart';
import 'package:ibdm/pages/server-status/server_status.dart';
import 'package:ibdm/pages/settings/emails/email_sents_page.dart';
import 'package:ibdm/pages/siroperie/siroperie.dart';
import 'package:ibdm/pages/utilite/utilite.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ibdm/utils/theme/theme.dart';
import 'package:ibdm/utils/theme/util.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LocaleController localeController = Get.put(LocaleController());
  final ThemeModeController themeModeController =
      Get.put(ThemeModeController());
  final UserController userController = Get.put(UserController());
  final RoutesController routesController = Get.put(RoutesController());
  final SideMenuStateController sideMenuStateController = Get.put(
      SideMenuStateController()); // This widget is the root of your application.
  final PermissionsController permissionsController =
      Get.put(PermissionsController());
  final LoadingPageController loadingPageController =
      Get.put(LoadingPageController());
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);
    return Obx(
      () => ShadApp.custom(
        themeMode: themeModeController.themeMode.value,
        darkTheme: ShadThemeData(
          colorScheme: ShadSlateColorScheme.dark(),
          brightness: Brightness.dark,
        ),
        theme: ShadThemeData(
          colorScheme: ShadSlateColorScheme.light(),
          brightness: Brightness.light,
        ),
        appBuilder: (context, shadTheme) => Obx(
          () => GetMaterialApp(
            initialBinding: InitialBinding(),
            title: 'IBDM - Ifri Base de Données Machines',
            locale: localeController.locale.value,
            themeMode: themeModeController.themeMode.value,
            theme: theme.light(),
            darkTheme: theme.dark(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.home,
            getPages: routesController.routes.value,
            textDirection: TextDirection.ltr,
            routingCallback: (routing) {
              if (!Routes.routePages.keys.contains(routing?.current)) {
                Get.toNamed(Routes.notFound);
                return;
              }

              if ((routing?.current != Routes.siroperie) &&
                  SiroperiePage.stream != null) {
                logger.e("closing siroperie channel");
                SiroperiePage.channel?.sink.close();
                SiroperiePage.stream = null;
              }

              if ((routing?.current != Routes.filtration) &&
                  (FiltrationPage.stream != null)) {
                logger.e("closing filtration channel");
                FiltrationPage.channel?.sink.close();
                FiltrationPage.stream = null;
              }

              if ((routing?.current != Routes.utilite) &&
                  (UtilitePage.stream != null)) {
                logger.e("closing utilite channel");
                UtilitePage.channel?.sink.close();
                UtilitePage.stream = null;
              }

              if ((routing?.current != Routes.emailSent) &&
                  (EmailSentsPage.stream != null)) {
                logger.e("closing sent emails channel");
                EmailSentsPage.channel?.sink.close();
                EmailSentsPage.stream = null;
              }

              if ((routing?.current != Routes.co2) &&
                  (CO2Page.stream != null)) {
                logger.e("closing co2 channel");
                CO2Page.channel?.sink.close();
                CO2Page.stream = null;
              }

              if ((routing?.current != Routes.serverStatus) &&
                  (ServerStatusPage.stream != null)) {
                logger.e("closing status channel");
                ServerStatusPage.channel?.sink.close();
                ServerStatusPage.stream = null;
              }

              logger.d("Route ${routing?.current}");
            },
            builder: (context, child) {
              try {
                return ShadToaster(child: child ?? Container());
              } catch (e) {
                logger.e("Error building app: $e");
              }
              return child ?? Container();
            },
            onUnknownRoute: (settings) {
              logger.e("Unknown route: ${settings.name}");
              Get.toNamed(Routes.notFound);
              return GetPageRoute(
                page: Routes.routePages[Routes.notFound]!.page,
                settings: settings,
              );
            },
          ),
        ),
      ),
    );
  }
}
