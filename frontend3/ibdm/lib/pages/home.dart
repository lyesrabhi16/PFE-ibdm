import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/actions_row.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/pages/loading_page.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LoadingPageController loadingPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final localeController = Get.find<LocaleController>();
    final userController = Get.find<UserController>();

    return Obx(() {
      return AppCustomContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(
              () => Center(
                child: Text(
                  textAlign: TextAlign.center,
                  strings.value.homePageWelcomeMessage,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
                "Current Language: ${localeController.locale.value.languageCode}"),
            SizedBox(height: AppSizes.md),
            FilledButton(
              child: Obx(() => Text(strings.value.login)),
              onPressed: () {
                Get.toNamed(Routes.login);
              },
            ),
            SizedBox(height: AppSizes.md),
            FilledButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
              ),
              onPressed: () {
                userController.logoutUser();
                Get.offAllNamed(Routes.login);
              },
              child: Text(strings.value.logout),
            ),
            SizedBox(height: AppSizes.md),
            ActionsRow(wrap: true),
          ],
        ),
      );
    });
  }
}
