import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/actions_row.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:toastification/toastification.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final localecontroller = Get.find<LocaleController>();
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
          FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(errorColor),
            ),
            onPressed: () {
              Get.find<UserController>().logoutUser();
              Get.offAllNamed(Routes.login);
            },
            child: Text(strings.value.logout),
          ),
          SizedBox(height: AppSizes.md),
          FilledButton(
            child: Text("protected"),
            onPressed: () {
              Get.toNamed("/protected");
            },
          ),
          SizedBox(height: AppSizes.md),
          ActionsRow(
            wrap: true,
          ),
        ],
      ),
    );
  }
}
