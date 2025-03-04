import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
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

  late final strings = getTranslations(getContext).obs;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Emails",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: AppSizes.md,
            ),
            Expanded(
              child: Wrap(
                children: [
                  SettingCard(
                    icon: Icons.email,
                    title: strings.value.emailSchedules,
                    subtitle: strings.value.emailSchedulesDescription,
                    onTap: () => {
                      Get.toNamed(Routes.emailSchedules),
                    },
                  ),
                  SettingCard(
                    icon: Icons.email,
                    title: strings.value.emailAlerts,
                    subtitle: strings.value.emailAlertsDescription,
                    onTap: () => {
                      Get.toNamed(Routes.emailAlerts),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
