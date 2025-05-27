import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:ibdm/common/controllers/permissions_controller.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/screen.dart';
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  strings.value.reports,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.sm),
                Column(
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
                SizedBox(height: AppSizes.xl),
                Column(children: [
                  Text(
                    strings.value.todaysReports,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  FutureBuilder<List<Widget>>(
                      future: Future.sync(() => getTodaysReports(context)),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loadingReports);
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(strings.value.errorLoadingReports),
                          );
                        }
                        return Column(children: [
                          ...snapshot.data!,
                        ]);
                      }),
                ])
              ],
            ),
          );
        }),
      ),
    );
  }
}

Future<List<Widget>> getTodaysReports(BuildContext context) async {
  final api = await ApiClientInstance.getApiClient();
  final PermissionsController permissionsController =
      Get.find<PermissionsController>();
  final reports = await Future.wait([
    if (permissionsController.hasPerm(Permissions.viewSucreReportsPage))
      api.generateReport(
        date: DateTime.now().toIso8601String(),
        reportType: ReportType.inventaireSucre,
      ),
    if (permissionsController.hasPerm(Permissions.viewFiltrationReportsPage))
      api.generateReport(
        date: DateTime.now().toIso8601String(),
        reportType: ReportType.filtration,
      ),
    if (permissionsController.hasPerm(Permissions.viewUtiliteReportsPage))
      api.generateReport(
        date: DateTime.now().toIso8601String(),
        reportType: ReportType.utilite,
      ),
    if (permissionsController.hasPerm(Permissions.viewCo2ReportsPage))
      api.generateReport(
        date: DateTime.now().toIso8601String(),
        reportType: ReportType.co2Ifruit,
      ),
  ]);

  return reports
      .map((report) => SettingCard(
            icon: switch (report.rapport.toLowerCase()) {
              'inventaire du sucre' => LucideIcons.boxes,
              'filtration' => Icons.battery_full_rounded,
              'utilite' => LucideIcons.gauge,
              'co2' => LucideIcons.cloud,
              _ => Icons.error,
            },
            title: report.rapport,
            subtitle: DateFormat("dd-MM-yyyy").format(report.date),
            onTap: () {
              showViewReportDialog(context, report);
            },
          ))
      .toList();
}

void showViewReportDialog(
  BuildContext context,
  Report report,
) {
  final strings = getTranslations(context).obs;
  final formattedReportDate = DateFormat('dd/MM/yyyy').format(report.date);

  showShadDialog(
    context: context,
    builder: (context) {
      return ShadDialog(
        title: Text(strings.value.viewReport(report.rapport),
            style: Theme.of(context).textTheme.headlineMedium),
        description: Text(
            strings.value.viewReportDescription(formattedReportDate),
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          ShadButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(strings.value.close),
          ),
        ],
        constraints: BoxConstraints(
          minWidth: min(context.width, 600),
          maxWidth: min(context.width, 600),
          minHeight: 700,
        ),
        child: Container(
          child: reportData(context, report),
        ),
      ).marginOnly(
        top: AppSizes.md,
      );
    },
  );
}

Widget reportData(BuildContext context, Report report) {
  final strings = getTranslations(context).obs;

  double tableWidth = 600;

  return Builder(builder: (context) {
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: tableWidth,
              maxWidth: tableWidth,
              minHeight: 300,
              maxHeight: 700,
            ),
            child: ShadTable.list(
              columnSpanExtent: (c) => FixedSpanExtent(
                  tableWidth / report.colNames.length - (c == 0 ? 0 : 16)),
              header: [
                for (var c in report.colNames)
                  ShadTableCell.header(child: Text(c.toString().toUpperCase())),
              ],
              rowSpanBackgroundDecoration: (c) => SpanDecoration(
                color: report.data[max(c - 1, 0)]["highlight"] == true
                    ? Theme.of(context).colorScheme.surfaceContainerLow
                    : Colors.transparent,
              ),
              children: [
                for (var r in report.data)
                  [
                    for (var c in report.colNames)
                      ShadTableCell(
                        child: AutoSizeText(
                          r[c] ?? "",
                          softWrap: false,
                          style: TextStyle(
                            overflow: report.colNames.indexOf(c) == 0
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            color: r["danger"] == true
                                ? errorColor
                                : r["highlight"] == true
                                    ? successColor
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                  ],
              ],
            ),
          ),
        ),
        if (report.synthese != null) ...[
          SizedBox(
            height: AppSizes.sm,
          ),
          Text(strings.value.synthese),
          SizedBox(
            height: AppSizes.sm,
          ),
          Text(
            report.synthese!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          )
        ]
      ],
    );
  });
}
