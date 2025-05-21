import 'package:flutter/material.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/common/controllers/theme_mode_controller.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final colorScheme = Theme.of(context).colorScheme;
    final localeController = Get.find<LocaleController>();

    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.value.settings,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                logger.e(
                    "EmailSettingsPage show Email settings: ${Container().withAnyPermissionOf([
                              Permissions.viewEmailAlerts,
                              Permissions.viewEmailSchedules,
                              Permissions.viewEmailsSent,
                            ]) != null ? true : false} ");
                return ListView(
                  children: [
                    SettingCard(
                      icon: Icons.email,
                      title: strings.value.email,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.emailSettings),
                    ).withAnyPermissionOf([
                      Permissions.viewEmailAlerts,
                      Permissions.viewEmailSchedules,
                      Permissions.viewEmailsSent,
                    ]),
                    SettingCard(
                      icon: Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      title: Get.isDarkMode
                          ? strings.value.lightmode
                          : strings.value.darkmode,
                      trailing: ThemeModeSwitchButton(),
                      onTap: () =>
                          Get.find<ThemeModeController>().toggleTheme(),
                    ),
                    SettingCard(
                      icon: Icons.language,
                      title: strings.value.language,
                      subtitle: localeController.locale.value.languageCode,
                      trailing: SizedBox(
                        height: 30,
                        width: 60,
                        child: LanguageSwitchButton(),
                      ),
                      onTap: () {
                        final int nextIndex = (localeController.supportedLocales
                                    .indexOf(localeController.locale.value) +
                                1) %
                            localeController.supportedLocales.length;
                        localeController.setLocale(
                            localeController.supportedLocales[nextIndex]);
                      },
                    ),
                    SettingCard(
                      icon: Icons.info,
                      title: strings.value.about,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.about),
                    ),
                    SettingCard(
                      icon: Icons.settings,
                      title: strings.value.serverSettings,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.serverSettings),
                    ).withPermission(Permissions.viewServerSettingsPage),
                  ].nonNulls.toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
