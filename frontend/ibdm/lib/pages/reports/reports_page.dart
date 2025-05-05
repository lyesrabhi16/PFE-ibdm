import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  Function? _getContext;
  BuildContext get context => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Obx(() {
          return Column(
            children: [
              Text(
                strings.value.reports,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSizes.sm),
              Expanded(
                child: ListView(
                  children: [
                    SettingCard(
                      icon: LucideIcons.boxes,
                      title: strings.value.sucreReports,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.sucreReports),
                    ).withPermission(Permissions.viewSucreReportsPage),
                    SettingCard(
                      icon: Icons.battery_full_rounded,
                      title: strings.value.filtrationReports,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.filtrationReports),
                    ).withPermission(Permissions.viewFiltrationReportsPage),
                    SettingCard(
                      icon: LucideIcons.gauge,
                      title: strings.value.utiliteReports,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.utiliteReports),
                    ).withPermission(Permissions.viewUtiliteReportsPage),
                    SettingCard(
                      icon: LucideIcons.cloud,
                      title: strings.value.co2Reports,
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          color: colorScheme.primary),
                      onTap: () => Get.toNamed(Routes.co2Reports),
                    ).withPermission(Permissions.viewCo2ReportsPage),
                  ].nonNulls.toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
