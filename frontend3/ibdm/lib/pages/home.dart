import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final localecontroller = Get.find<LocaleController>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(
              () => Center(
                child: Text(
                  strings.value.homePageWelcomeMessage,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
                "Current Language: ${localecontroller.locale.value.languageCode}"),
            SizedBox(height: AppSizes.md),
            FilledButton(
              child: Obx(() => Text(strings.value.login)),
              onPressed: () {
                // go to login page
                Get.toNamed(Routes.login);
              },
            ),
            SizedBox(height: AppSizes.md),
            ActionsRow(),
          ],
        ),
      ),
    );
  }
}

class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSizes.md,
      children: <Widget>[
        ThemeModeSwitchButton(),
        LanguageSwitchButton(),
        FilledButton(
          child: Text('Logout'),
          onPressed: () {
            Get.find<UserController>().logoutUser();
            Get.offAllNamed(Routes.login);
          },
        )
      ],
    );
  }
}
