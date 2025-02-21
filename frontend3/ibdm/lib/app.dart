import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/common/controllers/routes_controller.dart';
import 'package:ibdm/common/controllers/theme_mode_controller.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
//import 'package:ibdm/pages/login/loading_page.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ibdm/utils/theme/theme.dart';
import 'package:ibdm/utils/theme/util.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LocaleController localeController = Get.put(LocaleController());
  final ThemeModeController themeModeController =
      Get.put(ThemeModeController());
  final UserController userController = Get.put(UserController());
  final RoutesController routesController = Get.put(RoutesController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);

    return ShadApp.custom(
      appBuilder: (context, shadTheme) => Obx(
        () => GetMaterialApp(
          title: 'IBDM - Ifri Base de Données Machines',
          locale: localeController.locale.value,
          themeMode: themeModeController.themeMode.value,
          theme: theme.light(),
          darkTheme: theme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.home,
          getPages: routesController.routes,
          textDirection: TextDirection.ltr,
          builder: (context, child) {
            return ShadToaster(child: child!);
          },
          onUnknownRoute: (settings) {
            return GetPageRoute(
              page: () => Scaffold(
                body: Center(
                  child: Text("Page not found"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
