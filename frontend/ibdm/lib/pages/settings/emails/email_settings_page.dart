import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class EmailSettingsPage extends StatefulWidget {
  const EmailSettingsPage({super.key});

  @override
  State<EmailSettingsPage> createState() => _EmailSettingsPageState();
}

class _EmailSettingsPageState extends State<EmailSettingsPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              strings.value.emails,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: AppSizes.md,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  return Column(
                    children: [
                      SettingCard(
                        icon: Icons.email,
                        title: strings.value.emailSchedules,
                        subtitle: strings.value.emailSchedulesDescription,
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            color: colorScheme.primary),
                        onTap: () => {
                          Get.toNamed(Routes.emailSchedules),
                        },
                      ).withPermission(Permissions.viewEmailSchedules),
                      SettingCard(
                        icon: Icons.email,
                        title: strings.value.emailAlerts,
                        subtitle: strings.value.emailAlertsDescription,
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            color: colorScheme.primary),
                        onTap: () => {
                          Get.toNamed(Routes.emailAlerts),
                        },
                      ).withPermission(Permissions.viewEmailAlerts),
                      SettingCard(
                        icon: Icons.email,
                        title: strings.value.emailSents,
                        subtitle: strings.value.emailSentsDescription,
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            color: colorScheme.primary),
                        onTap: () => {
                          Get.toNamed(Routes.emailSent),
                        },
                      ).withPermission(Permissions.viewEmailsSent),
                    ].nonNulls.toList(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
