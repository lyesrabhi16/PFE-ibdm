import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/app_line_chart.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/cuve.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
import 'package:ibdm/common/widgets/multiple_data_lists.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/models/co2_ifruit_consommation.dart';
import 'package:ibdm/services/api_django/api_client/models/debit.dart';
import 'package:ibdm/services/api_django/api_client/models/feed_meta_data.dart';
import 'package:ibdm/services/api_django/api_client/models/fetch_type.dart';
import 'package:ibdm/services/api_django/api_client/models/filtration_meta_consommation.dart';
import 'package:ibdm/services/api_django/api_client/models/niveau.dart';
import 'package:ibdm/services/api_django/api_client/models/pres_cond.dart';
import 'package:ibdm/services/api_django/api_client/models/volume.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/graphs.dart';
import 'package:ibdm/utils/helpers/common_heplers.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:widget_arrows/widget_arrows.dart';
import 'package:ibdm/common/controllers/side_menu_state_controller.dart';

class FiltrationPage extends StatefulWidget {
  const FiltrationPage({super.key});

  static WebSocketChannel? channel;
  static Stream? stream;

  @override
  State<FiltrationPage> createState() => _FiltrationPageState();
}

class _FiltrationPageState extends State<FiltrationPage> {
  @override
  void dispose() {
    logger.e("running dispose filtration");
    FiltrationPage.channel?.sink.close();
    FiltrationPage.stream = null;
    super.dispose();
  }

  @override
  void deactivate() {
    logger.e("running deactivate filtration");
    FiltrationPage.channel?.sink.close();
    FiltrationPage.stream = null;
    super.deactivate();
  }

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  FeedMetaData? feedMetaData;

  final Rx<DateTime> filtrationStartDate = DateTime.now().obs;

  final Rx<DateTime> filtrationEndDate = DateTime.now().obs;

  final RxBool isLive = true.obs;

  final RxBool loaded = false.obs;

  int retries = 3;

  int? year;

  int? month;

  int? day;

  int? hour;

  int? minute;

  int? second;
  Rx<bool> refresh = false.obs;

  Niveau? niveau;
  Debit? debit;
  Volume? volume;
  PresCond? presCond;

  final Map<String, LinkedFiltrationData> linkedData = {};

  double F1_value = 0.0;
  double F2_value = 0.0;
  double UF1_value = 0.0;
  double UF2_value = 0.0;
  double OS1_value = 0.0;
  double OS2_value = 0.0;
  double OS3_value = 0.0;
  double OS4_value = 0.0;
  double OS5_value = 0.0;
  double OS6_value = 0.0;
  double OS7_value = 0.0;
  double get _somme_debit_forage => (debit!.dF1 ?? 0) + (debit!.dF2 ?? 0);
  double get _somme_debit_eau_brute =>
      (debit!.dUf1 ?? 0) +
      (debit!.dUf2 ?? 0) +
      (debit!.dUf3 ?? 0) +
      (debit!.dUf4 ?? 0) +
      (debit!.dUf5 ?? 0) +
      (debit!.dUf6 ?? 0);
  double get _somme_debit_eau_filtree_hytec =>
      (debit!.dOs1 ?? 0) + (debit!.dOs2 ?? 0) + (debit!.dOs3 ?? 0);
  double get _somme_debit_eau_filtree_osmotec =>
      (debit!.dOs4 ?? 0) +
      (debit!.dOs5 ?? 0) +
      (debit!.dOs6 ?? 0) +
      (debit!.dOs8 ?? 0) +
      (debit!.dOs9 ?? 0);
  double get _somme_volume_eau_brute =>
      (volume!.volUf1 ?? 0) +
      (volume!.volUf2 ?? 0) +
      (volume!.volUf3 ?? 0) +
      (volume!.volUf4 ?? 0) +
      (volume!.volUf5 ?? 0) +
      (volume!.volUf6 ?? 0);

  double get _somme_volume_eau_filtree_hytec =>
      (volume!.volOs1 ?? 0) + (volume!.volOs2 ?? 0) + (volume!.volOs3 ?? 0);
  double get _somme_volume_eau_filtree_osmotec =>
      (volume!.volOs4 ?? 0) +
      (volume!.volOs5 ?? 0) +
      (volume!.volOs6 ?? 0) +
      (volume!.volOs8 ?? 0) +
      (volume!.volOs9 ?? 0);
  double get _somme_volume_eau_filtree_osmosee =>
      _somme_volume_eau_filtree_hytec + _somme_volume_eau_filtree_osmotec;
  double get _somme_debit_eau_filtree_osmosee =>
      _somme_debit_eau_filtree_hytec + _somme_debit_eau_filtree_osmotec;

  final SideMenuStateController sideMenuStateController =
      Get.find<SideMenuStateController>();

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    return AppCustomContainer(
        child: Padding(
      padding: EdgeInsets.all(AppSizes.sm),
      child: Obx(() {
        if (retries == 0) {
          return Center(
            child: Text(strings.value.failedToConnectToFiltrationBroadcast(0)),
          );
        }
        if (!loaded.value) {
          printMessage("loading because of loaded value");
          load();
          logger.e("loading because of loaded value");
          return CircularProgressIndicatorWithText(
            text: strings.value.loading,
          );
        }

        if (refresh.value) {
          refresh.value = false;
        }

        if (feedMetaData == null) {
          return CircularProgressIndicatorWithText(
            text: strings.value.loading,
          );
        }
        try {
          return _build();
        } catch (e) {
          printMessage("error: $e");
          FiltrationPage.channel?.sink.close();
          FiltrationPage.stream = null;
          load();
          return CircularProgressIndicatorWithText(
            text: strings.value.loading,
          );
        }
      }),
    ));
  }

  _build() {
    final strings = getTranslations(context).obs;
    return Column(
      children: [
        Text(
          strings.value.filtrationTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(
          height: AppSizes.sm,
        ),
        // top actions bar
        Container(
          width: context.width,
          decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.borderRadius),
                topRight: Radius.circular(AppSizes.borderRadius),
              )),
          child: _getTopActionsBar(),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FiltrationPage.stream,
              builder: (context, snapshot) {
                //printMessage("snapshot: $snapshot");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  printMessage("waiting for connection");
                  return CircularProgressIndicatorWithText(
                    text: strings.value.waitingForConnection,
                  );
                }
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.hasError ||
                    snapshot.data.isEmpty) {
                  logger.e("loading inside of stream builder");
                  if (FiltrationPage.channel?.closeCode != null ||
                      snapshot.connectionState != ConnectionState.active) {
                    logger.e("closing channel");
                    FiltrationPage.channel?.sink.close();
                    FiltrationPage.stream = null;
                    logger.e("reopening channel...");
                    Future.delayed(Duration(seconds: 1), load);
                  }
                  return CircularProgressIndicatorWithText(
                    text: strings.value.reconnecting,
                  );
                }
                final data = JsonCodec().decode(snapshot.data);
                if (data["data"] == null || data["data"].isEmpty) {
                  logger.e("data is null");
                  return CircularProgressIndicatorWithText(
                    text: strings.value.waitingForValidData,
                  );
                }
                if (isLive.value) {
                  niveau = Niveau.fromJson(data["data"]["niveau"]);
                  debit = Debit.fromJson(data["data"]["debit"]);
                  volume = Volume.fromJson(data["data"]["volume"]);
                  presCond = PresCond.fromJson(data["data"]["pres_cond"]);

                  Future.delayed(Duration(microseconds: 100),
                      () => filtrationEndDate.value = niveau!.date);
                  year = niveau!.date.year;
                  month = niveau!.date.month;
                  day = niveau!.date.day;
                  hour = niveau!.date.hour;
                  minute = niveau!.date.minute;
                  second = niveau!.date.second;
                }

                F1_value = (niveau!.nivF1 ?? 0) * 100 / 450;
                F2_value = (niveau!.nivF2 ?? 0) * 100 / 450;
                UF1_value = (niveau!.nivUf1 ?? 0) * 100 / 520;
                UF2_value = (niveau!.nivUf2 ?? 0) * 100 / 520;
                OS1_value = (niveau!.nivOs1 ?? 0) * 100 / 60;
                OS2_value = (niveau!.nivOs2 ?? 0) * 100 / 60;
                OS3_value = (niveau!.nivOs3 ?? 0) * 100 / 60;
                OS4_value = (niveau!.nivOs4 ?? 0) * 100 / 180;
                OS5_value = (niveau!.nivOs5 ?? 0) * 100 / 45;
                OS6_value = (niveau!.nivOs6 ?? 0) * 100 / 45;
                OS7_value = (niveau!.nivOs7 ?? 0) * 100 / 10;
                return Container(
                  constraints: BoxConstraints(),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.borderRadius),
                      bottomRight: Radius.circular(AppSizes.borderRadius),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: ArrowContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ArrowElement(
                                id: "forage_eau_brute",
                                targetId: "eau_brute",
                                sourceAnchor: Alignment.centerRight,
                                straights: true,
                                color: successColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: successColor,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadius),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 200,
                                                maxWidth: 200,
                                              ),
                                              child: DividerWithText(
                                                text: "Débit",
                                                color: colorScheme.onPrimary,
                                              ),
                                            ),
                                            Text(
                                              "${_somme_debit_forage.toStringAsFixed(2)} M3/H",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            ),
                                            Text(
                                              "F1 : ${(debit!.dF1 ?? 0).toStringAsFixed(2)} M3/H",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            ),
                                            Text(
                                              "F2 : ${(debit!.dF2 ?? 0).toStringAsFixed(2)} M3/H",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 200,
                                                maxWidth: 200,
                                              ),
                                              child: DividerWithText(
                                                text: "Volume",
                                                color: colorScheme.onPrimary,
                                              ),
                                            ),
                                            Text(
                                              "${(volume!.volFor ?? 0).toStringAsFixed(2)} M3",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: AppSizes.lg,
                              ),
                              ArrowElement(
                                id: "eau_brute",
                                targetId: "data_eau_brute_filtrer",
                                straights: true,
                                tipLength: 0,
                                sourceAnchor: Alignment.centerRight,
                                color: successColor,
                                child: Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.borderRadius),
                                      border: Border.all(
                                        width: 2,
                                        color: successColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: _eauBrute(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: AppSizes.lg,
                              ),
                              ArrowElement(
                                id: "data_eau_brute_filtrer",
                                targetId: "eau_filtrer",
                                sourceAnchor: Alignment.centerRight,
                                straights: true,
                                color: successColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: successColor,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadius),
                                  ),
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.all(AppSizes.sm),
                                      child: SizedBox(
                                        width: 400,
                                        height: 400,
                                        child: ShadTable.list(
                                          columnSpanExtent: (i) =>
                                              FixedTableSpanExtent(100),
                                          header: [
                                            ShadTableCell.header(
                                                child: Text(
                                              "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            )),
                                            ShadTableCell.header(
                                                child: Text(
                                              "Débit",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            )),
                                            ShadTableCell.header(
                                                child: Text(
                                              "Volume",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            )),
                                            ShadTableCell.header(
                                                child: Text(
                                              "Pression",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            ))
                                          ],
                                          rowSpanBackgroundDecoration: (row) =>
                                              SpanDecoration(
                                            color: Colors.transparent,
                                          ),
                                          children: [
                                            _dataRow(
                                                title: "Total",
                                                debit: _somme_debit_eau_brute,
                                                volume: _somme_volume_eau_brute,
                                                pression: (presCond!.pUf ?? 0),
                                                bold: true),
                                            _dataRow(
                                              title: "UF1",
                                              debit: (debit!.dUf1 ?? 0),
                                              volume: (volume!.volUf1 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF2",
                                              debit: (debit!.dUf2 ?? 0),
                                              volume: (volume!.volUf2 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF3",
                                              debit: (debit!.dUf3 ?? 0),
                                              volume: (volume!.volUf3 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF4",
                                              debit: (debit!.dUf4 ?? 0),
                                              volume: (volume!.volUf4 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF5",
                                              debit: (debit!.dUf5 ?? 0),
                                              volume: (volume!.volUf5 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF6",
                                              debit: (debit!.dUf6 ?? 0),
                                              volume: (volume!.volUf6 ?? 0),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: AppSizes.lg,
                              ),
                              ArrowElement(
                                id: "eau_filtrer",
                                targetIds: [
                                  "data_eau_filtrer_hytec",
                                  "data_eau_filtrer_osmosee"
                                ],
                                sourceAnchor: Alignment.bottomCenter,
                                bow: 0,
                                straights: true,
                                stretch: 0,
                                tipLength: 0,
                                targetAnchor: Alignment.topCenter,
                                color: colorScheme.primary,
                                child: Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.borderRadius),
                                      border: Border.all(
                                        width: 2,
                                        color: colorScheme.primary,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: _eauFiltrer(),
                                  ),
                                ),
                              ),
                            ],
                          ).removeWhen(spaceIsNotEnough()),
                          Column(
                            children: [
                              ArrowElement(
                                id: "forage_eau_brute",
                                targetId: "eau_brute",
                                sourceAnchor: Alignment.bottomCenter,
                                targetAnchor: Alignment.topCenter,
                                straights: true,
                                color: successColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: successColor,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadius),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 200,
                                            maxWidth: 200,
                                          ),
                                          child: DividerWithText(
                                            text: "Débit",
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                        Text(
                                          "${_somme_debit_forage.toStringAsFixed(2)} M3/H",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                              ),
                                        ),
                                        Text(
                                          "F1 : ${(debit!.dF1 ?? 0).toStringAsFixed(2)} M3/H",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                              ),
                                        ),
                                        Text(
                                          "F2 : ${(debit!.dF2 ?? 0).toStringAsFixed(2)} M3/H",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                              ),
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 200,
                                            maxWidth: 200,
                                          ),
                                          child: DividerWithText(
                                            text: "Volume",
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                        Text(
                                          "${(volume!.volFor ?? 0).toStringAsFixed(2)} M3",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                              ),
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 200,
                                            maxWidth: 200,
                                          ),
                                          child: DividerWithText(
                                            text: "Pression",
                                            color: colorScheme.onPrimary,
                                          ),
                                        ),
                                        Text(
                                          "${(presCond!.pUf ?? 0).toStringAsFixed(2)} Bars",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.lg,
                              ),
                              ArrowElement(
                                id: "eau_brute",
                                targetId: "data_eau_brute_filtrer",
                                straights: true,
                                tipLength: 0,
                                sourceAnchor: Alignment.bottomCenter,
                                targetAnchor: Alignment.topCenter,
                                color: successColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadius),
                                    border: Border.all(
                                      width: 2,
                                      color: successColor,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: _eauBrute(),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.lg,
                              ),
                              ArrowElement(
                                id: "data_eau_brute_filtrer",
                                targetId: "eau_filtrer",
                                sourceAnchor: Alignment.bottomCenter,
                                targetAnchor: Alignment.topCenter,
                                straights: true,
                                color: successColor,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: successColor,
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadius),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: SizedBox(
                                      width: 400,
                                      height: 400,
                                      child: ShadTable.list(
                                        columnSpanExtent: (i) =>
                                            FixedTableSpanExtent(100),
                                        header: [
                                          ShadTableCell.header(
                                              child: Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: colorScheme.onPrimary,
                                                ),
                                          )),
                                          ShadTableCell.header(
                                              child: Text(
                                            "Débit",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: colorScheme.onPrimary,
                                                ),
                                          )),
                                          ShadTableCell.header(
                                              child: Text(
                                            "Volume",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: colorScheme.onPrimary,
                                                ),
                                          )),
                                          ShadTableCell.header(
                                              child: Text(
                                            "Pression",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  color: colorScheme.onPrimary,
                                                ),
                                          ))
                                        ],
                                        rowSpanBackgroundDecoration: (row) =>
                                            SpanDecoration(
                                          color: Colors.transparent,
                                        ),
                                        children: [
                                          _dataRow(
                                              title: "Total",
                                              debit: _somme_debit_eau_brute,
                                              volume: _somme_volume_eau_brute,
                                              pression: (presCond!.pUf ?? 0),
                                              bold: true),
                                          _dataRow(
                                            title: "UF1",
                                            debit: (debit!.dUf1 ?? 0),
                                            volume: (volume!.volUf1 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF2",
                                            debit: (debit!.dUf2 ?? 0),
                                            volume: (volume!.volUf2 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF3",
                                            debit: (debit!.dUf3 ?? 0),
                                            volume: (volume!.volUf3 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF4",
                                            debit: (debit!.dUf4 ?? 0),
                                            volume: (volume!.volUf4 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF5",
                                            debit: (debit!.dUf5 ?? 0),
                                            volume: (volume!.volUf5 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF6",
                                            debit: (debit!.dUf6 ?? 0),
                                            volume: (volume!.volUf6 ?? 0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.lg,
                              ),
                              ArrowElement(
                                id: "eau_filtrer",
                                targetIds: [
                                  "data_eau_filtrer_hytec",
                                  "data_eau_filtrer_osmosee"
                                ],
                                sourceAnchor: Alignment.bottomCenter,
                                targetAnchor: Alignment.topCenter,
                                bow: 0,
                                straights: true,
                                stretch: 0,
                                tipLength: 0,
                                color: colorScheme.primary,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSizes.borderRadius),
                                    border: Border.all(
                                      width: 2,
                                      color: colorScheme.primary,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: _eauFiltrer(),
                                ),
                              ),
                            ],
                          ).removeWhen(!spaceIsNotEnough()),
                          SizedBox(
                            height: AppSizes.xl * 2,
                          ),
                          Center(
                            child: ArrowElement(
                              id: "data_eau_filtrer_osmosee",
                              targetId: "osmosee",
                              sourceAnchor: Alignment.bottomCenter,
                              targetAnchor: Alignment.topCenter,
                              straights: true,
                              bow: 0,
                              stretch: 0,
                              color: colorScheme.primary,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.borderRadius),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSizes.sm),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 400,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(AppSizes.sm),
                                          child: Center(
                                            child: Wrap(
                                                alignment:
                                                    WrapAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    "TOTAL ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorScheme
                                                              .onPrimary,
                                                        ),
                                                  ),
                                                  SizedBox(width: AppSizes.sm),
                                                  Text(
                                                    "Debit : ${_somme_debit_eau_filtree_osmosee.toStringAsFixed(2)} M3/H",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorScheme
                                                              .onPrimary,
                                                        ),
                                                  ),
                                                  SizedBox(width: AppSizes.sm),
                                                  Text(
                                                    "Volume: ${_somme_volume_eau_filtree_osmosee.toStringAsFixed(2)} M3",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorScheme
                                                              .onPrimary,
                                                        ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 400,
                                        child: Divider(
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                                      Wrap(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            height: 300,
                                            child: ShadTable.list(
                                              columnSpanExtent: (i) =>
                                                  FixedTableSpanExtent(100),
                                              header: [
                                                ShadTableCell.header(
                                                    child: Text(
                                                  "Hytec",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                )),
                                                ShadTableCell.header(
                                                    child: Text(
                                                  "Débit",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                )),
                                                ShadTableCell.header(
                                                    child: Text(
                                                  "Volume",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                )),
                                              ],
                                              rowSpanBackgroundDecoration:
                                                  (row) => SpanDecoration(
                                                color: Colors.transparent,
                                              ),
                                              children: [
                                                _dataRow(
                                                  title: "Total Hytec",
                                                  debit:
                                                      _somme_debit_eau_filtree_hytec,
                                                  volume:
                                                      _somme_volume_eau_filtree_hytec,
                                                  bold: true,
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS1",
                                                  debit: (debit!.dOs1 ?? 0),
                                                  volume: (volume!.volOs1 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS2",
                                                  debit: (debit!.dOs2 ?? 0),
                                                  volume: (volume!.volOs2 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS3",
                                                  debit: (debit!.dOs3 ?? 0),
                                                  volume: (volume!.volOs3 ?? 0),
                                                  showPression: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 350,
                                            child: VerticalDivider(
                                              color: colorScheme.onPrimary,
                                            ),
                                          ).removeWhen(
                                              isAtMostSmallScreen(context)),
                                          SizedBox(
                                            width: 300,
                                            height: 350,
                                            child: ShadTable.list(
                                              columnSpanExtent: (i) =>
                                                  FixedTableSpanExtent(100),
                                              header: [
                                                ShadTableCell.header(
                                                    child: Text(
                                                  "Osmotec",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                )),
                                                ShadTableCell.header(
                                                    child: Text(
                                                  "Débit",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                )),
                                                ShadTableCell.header(
                                                    child: Text(
                                                  "Volume",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onPrimary,
                                                      ),
                                                )),
                                              ],
                                              rowSpanBackgroundDecoration:
                                                  (row) => SpanDecoration(
                                                color: Colors.transparent,
                                              ),
                                              children: [
                                                _dataRow(
                                                  title: "Total Osmotec",
                                                  debit:
                                                      _somme_debit_eau_filtree_osmotec,
                                                  volume:
                                                      _somme_volume_eau_filtree_osmotec,
                                                  bold: true,
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS4",
                                                  debit: (debit!.dOs4 ?? 0),
                                                  volume: (volume!.volOs4 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS5",
                                                  debit: (debit!.dOs5 ?? 0),
                                                  volume: (volume!.volOs5 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS6",
                                                  debit: (debit!.dOs6 ?? 0),
                                                  volume: (volume!.volOs6 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS8",
                                                  debit: (debit!.dOs8 ?? 0),
                                                  volume: (volume!.volOs8 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS9",
                                                  debit: (debit!.dOs9 ?? 0),
                                                  volume: (volume!.volOs9 ?? 0),
                                                  showPression: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ].nonNulls.toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppSizes.xl,
                          ),
                          ArrowElement(
                            id: "osmosee",
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppSizes.borderRadius),
                                border: Border.all(
                                  width: 2,
                                  color: colorScheme.primaryContainer,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: _eauOsmosee(),
                            ).marginAll(AppSizes.sm),
                          ),
                        ].nonNulls.toList(),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  _getFiltrationData() async {
    final strings = getTranslations(context);
    final _state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: getContext,
        messageSuccess: strings.dataFound,
        message: strings.retrievingData,
        messageError: strings.dataNotFound,
        state: _state);

    try {
      logger
          .e("Getting filtration data $year $month $day $hour $minute $second");
      final api = await ApiClientInstance.getApiClient();
      _setDone() {
        refresh.value = true;
        _state.value = FutureState.success;
        loaded.value = true;
        Future.delayed(Durations.long2, () {
          toastification.dismissById(toast.id);
        });
      }

      final List<dynamic> v = await Future.wait([
        api.getNiveauAtSpecificTime(
          year: year!,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
        ),
        api.getDebitAtSpecificTime(
          year: year!,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
        ),
        api.getVolumeAtSpecificTime(
          year: year!,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
        ),
        api.getPresCondAtSpecificTime(
          year: year!,
          month: month,
          day: day,
          hour: hour,
          minute: minute,
          second: second,
        ),
      ]);

      niveau = v[0] as Niveau;
      debit = v[1] as Debit;
      volume = v[2] as Volume;
      presCond = v[3] as PresCond;

      _setDone();
    } catch (e) {
      logger.e("Failed to get filtration data : $e");
      _state.value = FutureState.error;
      loaded.value = true;
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
      return null;
    } finally {
      filtrationEndDate.value = niveau!.date;
      refresh.value = !refresh.value;
    }
  }

  _openConsommationDialog() async {
    final strings = getTranslations(getContext).obs;
    FiltrationMetaConsommation? cons;
    final now = DateTime.now();
    final toDate = DateTime(
      year ?? now.year,
      month ?? now.month,
      day ?? now.day,
    );
    final fromDate = toDate;
    final Rx<DateTimeRange> _selectedDateRange = DateTimeRange(
      start: fromDate,
      end: toDate,
    ).obs;

    final Rx<bool> _dataLoaded = false.obs;
    final Rx<bool> _failed = false.obs;
    int retries = 3;
    _getConsData() async {
      _dataLoaded.value = false;

      try {
        cons = await (await ApiClientInstance.getApiClient())
            .getFiltrationConsommation(
          fromYear: _selectedDateRange.value.start.year,
          fromMonth: _selectedDateRange.value.start.month,
          fromDay: _selectedDateRange.value.start.day,
          toYear: _selectedDateRange.value.end.year,
          toMonth: _selectedDateRange.value.end.month,
          toDay: _selectedDateRange.value.end.day,
        );
        _failed.value = false;
        _dataLoaded.value = true;
      } catch (e) {
        if (retries > 0) {
          retries--;
          _getConsData();
        } else {
          retries = 3;

          _failed.value = true;
          _dataLoaded.value = true;
          Toasts.showErrorToast(
            context: getContext,
            message: strings.value.failedToLoadData,
          );
        }
      }
    }

    return showShadDialog(
      context: getContext,
      builder: (context) => ShadDialog(
        title: Text(
          strings.value.consommation,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        description: Text(strings.value.consommationDescription),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                ShadDatePicker.range(
                  onRangeChanged: (value) => {
                    _selectedDateRange.value = DateTimeRange(
                      start: value?.start ?? _selectedDateRange.value.start,
                      end: value?.end ?? value!.start!,
                    ),
                  },
                  closeOnSelection: false,
                  closeOnTapOutside: true,
                  selectableDayPredicate: (day) =>
                      day.isSameDayOrGreatier(filtrationStartDate.value) &&
                      day.isSameDayOrLower(filtrationEndDate.value),
                  allowDeselection: false,
                  formatDateRange: (dateRange) =>
                      dateTimeRangeToString(dateRange.start, dateRange.end),
                  selected: ShadDateTimeRange(
                    start: _selectedDateRange.value.start,
                    end: _selectedDateRange.value.end,
                  ),
                  initialMonth: _selectedDateRange.value.start,
                  fromMonth: filtrationStartDate.value,
                  toMonth: filtrationEndDate.value,
                ),
                ShadButton(
                  icon: Icon(LucideIcons.search),
                  onPressed: () {
                    _getConsData();
                  },
                  child: Text(strings.value.find),
                ),
              ],
            ),
            Obx(() {
              if (!_dataLoaded.value) {
                _getConsData();
                return SizedBox(
                    height: 600,
                    child: CircularProgressIndicatorWithText(
                      text: strings.value.loading,
                    ));
              }
              if (_failed.value) {
                return Text(strings.value.failedToLoadData);
              }
              return Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: context.width,
                        minHeight: 300,
                        maxHeight: 680,
                      ),
                      child: ShadTable.list(
                        columnSpanExtent: (t) => FixedTableSpanExtent(
                            [0].contains(t) ? 150 : context.width - (150)),
                        header: [
                          ShadTableCell.header(child: Text(strings.value.name)),
                          ShadTableCell.header(
                              child: Text(strings.value.value)),
                        ],
                        children: [
                          for (var r in [
                            DataRepresentation(
                              name: "forage",
                              code: "forage",
                              source: cons?.consommation.toJson(),
                            ),
                            DataRepresentation(
                              name: "eau brute",
                              code: "eau_brute",
                              source: cons?.consommation.toJson(),
                            ),
                            DataRepresentation(
                              name: "hytec",
                              code: "hytec",
                              source: cons?.consommation.toJson(),
                            ),
                            DataRepresentation(
                              name: "osmotec",
                              code: "osmotec",
                              source: cons?.consommation.toJson(),
                            ),
                            DataRepresentation(
                              name: "osmosee",
                              code: "osmosee",
                              source: cons?.consommation.toJson(),
                            ),
                            DataRepresentation(
                              name: "contre lavage",
                              code: "contre_lavage",
                              source: cons?.consommation.toJson(),
                            ),
                          ])
                            [
                              ShadTableCell(
                                child: Text(
                                  r.name,
                                  softWrap: false,
                                ),
                              ),
                              ShadTableCell(
                                child: Text(
                                  (r.value?.toStringAsFixed(2) ?? "")
                                      .toString(),
                                  softWrap: false,
                                ),
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ).marginOnly(
        top: AppSizes.md,
      ),
    );
  }

  _getTopActionsBar() {
    final strings = getTranslations(context).obs;

    return LiveDataTopActionBar(
      isLive: isLive,
      startDate: feedMetaData!.startDate,
      endDate: feedMetaData!.endDate,
      selectedDate: filtrationEndDate.value,
      searchPressed: (dt) {
        year = dt.year;
        month = dt.month;
        day = dt.day;
        hour = dt.hour;
        minute = dt.minute;
        second = dt.second;
        _getFiltrationData();
      },
      afterDataDisplayWidgets: [
        ShadButton(
          icon: Icon(LucideIcons.clipboardList),
          onPressed: () => _openConsommationDialog(),
          child: Text(strings.value.consommation),
        )
      ],
      graphPressed: () {
        showShadDialog(
          context: context,
          builder: (context) => ShadDialog(
            constraints: BoxConstraints(
              minWidth: min(context.width, 600),
              maxWidth: min(context.width, 800),
              minHeight: min(context.height, 600),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        )).marginAll(AppSizes.md),
                AppLineChart(
                  graphTypes: [
                    GraphType(
                      name: "Niveau",
                      getGraphData: Graphs.getFiltrationNiveauGraphData,
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Niveau Eau Brute détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationNiveauGraphData(
                        start,
                        end,
                        fetchType,
                        includeEauBrute: true,
                        includeEauFiltre: false,
                        includeEauOsmosee: false,
                        includeHytec: false,
                        includeOsmotec: false,
                        includeDoubleOsmose: false,
                        detailEauBrute: true,
                        detailEauFiltre: false,
                        detailEauOsmosee: false,
                        detailHytec: false,
                        detailOsmotec: false,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Niveau Eau Filtrée détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationNiveauGraphData(
                        start,
                        end,
                        fetchType,
                        includeEauBrute: false,
                        includeEauFiltre: true,
                        includeEauOsmosee: false,
                        includeHytec: false,
                        includeOsmotec: false,
                        includeDoubleOsmose: false,
                        detailEauBrute: false,
                        detailEauFiltre: true,
                        detailEauOsmosee: false,
                        detailHytec: false,
                        detailOsmotec: false,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Niveau Eau Osmosée détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationNiveauGraphData(
                        start,
                        end,
                        fetchType,
                        includeEauBrute: false,
                        includeEauFiltre: false,
                        includeEauOsmosee: true,
                        includeHytec: false,
                        includeOsmotec: false,
                        includeDoubleOsmose: false,
                        detailEauBrute: false,
                        detailEauFiltre: false,
                        detailEauOsmosee: true,
                        detailHytec: false,
                        detailOsmotec: false,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Niveau Hytec détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationNiveauGraphData(
                        start,
                        end,
                        fetchType,
                        includeEauBrute: false,
                        includeEauFiltre: false,
                        includeEauOsmosee: false,
                        includeHytec: true,
                        includeOsmotec: false,
                        includeDoubleOsmose: false,
                        detailEauBrute: false,
                        detailEauFiltre: false,
                        detailEauOsmosee: false,
                        detailHytec: true,
                        detailOsmotec: false,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Niveau Osmotec détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationNiveauGraphData(
                        start,
                        end,
                        fetchType,
                        includeEauBrute: false,
                        includeEauFiltre: false,
                        includeEauOsmosee: false,
                        includeHytec: false,
                        includeOsmotec: true,
                        includeDoubleOsmose: false,
                        detailEauBrute: false,
                        detailEauFiltre: false,
                        detailEauOsmosee: false,
                        detailHytec: false,
                        detailOsmotec: true,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Pression",
                      getGraphData: Graphs.getFiltrationPressionGraphData,
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Pression OS",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationPressionGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: true,
                        includeUF: false,
                      ),
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Pression OSE",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationPressionGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: false,
                        includeUF: false,
                        includeOSE: true,
                      ),
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Pression Hytec",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationPressionGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: false,
                        includeUF: false,
                        includeHytec: true,
                      ),
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Pression Osmotec",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationPressionGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: false,
                        includeUF: false,
                        includeOsmotec: true,
                      ),
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Pression Utilité",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationPressionGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: false,
                        includeUF: false,
                        includeUtilite: true,
                      ),
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Pression UF",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationPressionGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: false,
                        includeUF: true,
                        includeOSE: false,
                      ),
                      ySuffix: " Bars",
                    ),
                    GraphType(
                      name: "Débit",
                      getGraphData: Graphs.getFiltrationDebitGraphData,
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Débit UF détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationDebitGraphData(
                        start,
                        end,
                        fetchType,
                        includeForage: false,
                        includeUF: true,
                        includeOS: false,
                        detailUF: true,
                      ),
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Débit OS détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationDebitGraphData(
                        start,
                        end,
                        fetchType,
                        includeForage: false,
                        includeUF: false,
                        includeOS: true,
                        detailOS: true,
                      ),
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Débit OS",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationDebitGraphData(
                        start,
                        end,
                        fetchType,
                        includeForage: false,
                        includeUF: false,
                        includeOS: false,
                        includeHytec: true,
                        includeOsmotec: true,
                      ),
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Débit Hytec",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationDebitGraphData(
                        start,
                        end,
                        fetchType,
                        includeForage: true,
                        includeUF: false,
                        includeOS: false,
                        detailForage: false,
                        includeHytec: true,
                        detailHytec: true,
                      ),
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Débit Osmotec",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationDebitGraphData(
                        start,
                        end,
                        fetchType,
                        includeForage: false,
                        includeUF: false,
                        includeOS: false,
                        detailForage: false,
                        includeOsmotec: true,
                        detailOsmotec: true,
                      ),
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Débit Forage détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationDebitGraphData(
                        start,
                        end,
                        fetchType,
                        includeForage: true,
                        includeUF: false,
                        includeOS: false,
                        detailForage: true,
                      ),
                      ySuffix: " M3/H",
                    ),
                    GraphType(
                      name: "Volume",
                      getGraphData: Graphs.getFiltrationVolumeGraphData,
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Volume UF détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationVolumeGraphData(
                        start,
                        end,
                        fetchType,
                        includeContreLavage: false,
                        includeForage: false,
                        includeUF: true,
                        includeOS: false,
                        detailUF: true,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Volume OS détaillé",
                      getGraphData: (start, end, fetchType) =>
                          Graphs.getFiltrationVolumeGraphData(
                        start,
                        end,
                        fetchType,
                        includeContreLavage: false,
                        includeForage: false,
                        includeUF: false,
                        includeOS: true,
                        detailOS: true,
                      ),
                      ySuffix: " M3",
                    ),
                    GraphType(
                      name: "Conductivité",
                      getGraphData: Graphs.getFiltrationConductiviteGraphData,
                      ySuffix: " µS",
                    ),
                    GraphType(
                      name: "Conductivité OS",
                      getGraphData: (
                        start,
                        end,
                        fetchType,
                      ) =>
                          Graphs.getFiltrationConductiviteGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: true,
                        includeUF: false,
                      ),
                      ySuffix: " µS",
                    ),
                    GraphType(
                      name: "Conductivité UF",
                      getGraphData: (
                        start,
                        end,
                        fetchType,
                      ) =>
                          Graphs.getFiltrationConductiviteGraphData(
                        start,
                        end,
                        fetchType,
                        includeOS: false,
                        includeUF: true,
                      ),
                      ySuffix: " µS",
                    ),
                    GraphType(
                      name: "Consommation",
                      supportsFetchType: false,
                      getGraphData: Graphs.getFiltrationConsommationGraphData,
                      ySuffix: " M3",
                    ),
                  ],
                ),
              ],
            ),
          ).marginOnly(
            top: AppSizes.md,
          ),
        );
      },
      listPressed: () {
        logger.e("list pressed");
        showShadDialog(
          variant: ShadDialogVariant.alert,
          context: Get.context!,
          builder: (context) {
            logger.e("buliding shad dialog");
            return ShadDialog(
              constraints: BoxConstraints(
                minWidth: min(context.width, 600),
                maxWidth: min(context.width, 800),
              ),
              child: MultipleDataLists(
                tabs: [
                  DataListTab(
                    name: strings.value.niveau,
                    onTap: showDataDialog,
                    getData: (start, end, page) async {
                      final api = await ApiClientInstance.getApiClient();
                      final res = await api.getNiveauxBetweenDates(
                        startDate: start.toIso8601String(),
                        endDate: end.toIso8601String(),
                        page: page,
                        perPage: 100,
                      );
                      final List<DataRepresentation> list = [];
                      for (var s in res.data) {
                        list.add(DataRepresentation(
                            name: strings.value.date,
                            code: "date",
                            source: s.toJson(),
                            transform: (dateString) {
                              final date = DateTime.parse(dateString);
                              return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year.toString().padLeft(2, "0")}   ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}.${date.millisecond}";
                            }));

                        if (linkedData.containsKey(s.date.toIso8601String())) {
                          linkedData[s.date.toIso8601String()]!.niveau = s;
                        } else {
                          linkedData[s.date.toIso8601String()] =
                              LinkedFiltrationData(
                            dateTime: s.date,
                            niveau: s,
                          );
                        }
                      }
                      final json_data = res.toJson();
                      json_data["data"] = list;
                      return json_data;
                    },
                  ),
                  DataListTab(
                    name: strings.value.volume,
                    onTap: showDataDialog,
                    getData: (start, end, page) async {
                      final api = await ApiClientInstance.getApiClient();
                      final res = await api.getVolumesBetweenDates(
                        startDate: start.toIso8601String(),
                        endDate: end.toIso8601String(),
                        page: page,
                        perPage: 100,
                      );
                      final List<DataRepresentation> list = [];
                      for (var s in res.data) {
                        list.add(DataRepresentation(
                            name: strings.value.date,
                            code: "date",
                            source: s.toJson(),
                            transform: (dateString) {
                              final date = DateTime.parse(dateString);
                              return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year.toString().padLeft(2, "0")}   ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}.${date.millisecond}";
                            }));

                        if (linkedData.containsKey(s.date.toIso8601String())) {
                          linkedData[s.date.toIso8601String()]!.volume = s;
                        } else {
                          linkedData[s.date.toIso8601String()] =
                              LinkedFiltrationData(
                            dateTime: s.date,
                            volume: s,
                          );
                        }
                      }
                      final json_data = res.toJson();
                      json_data["data"] = list;
                      return json_data;
                    },
                  ),
                  DataListTab(
                    name: strings.value.debit,
                    onTap: showDataDialog,
                    getData: (start, end, page) async {
                      final api = await ApiClientInstance.getApiClient();
                      final res = await api.getDebitsBetweenDates(
                        startDate: start.toIso8601String(),
                        endDate: end.toIso8601String(),
                        page: page,
                        perPage: 100,
                      );
                      final List<DataRepresentation> list = [];
                      for (var s in res.data) {
                        list.add(DataRepresentation(
                            name: strings.value.date,
                            code: "date",
                            source: s.toJson(),
                            transform: (dateString) {
                              final date = DateTime.parse(dateString);
                              return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year.toString().padLeft(2, "0")}   ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}.${date.millisecond}";
                            }));
                        if (linkedData.containsKey(s.date.toIso8601String())) {
                          linkedData[s.date.toIso8601String()]!.debit = s;
                        } else {
                          linkedData[s.date.toIso8601String()] =
                              LinkedFiltrationData(
                            dateTime: s.date,
                            debit: s,
                          );
                        }
                      }
                      final json_data = res.toJson();
                      json_data["data"] = list;
                      return json_data;
                    },
                  ),
                  DataListTab(
                    name: strings.value.presCond,
                    onTap: showDataDialog,
                    getData: (start, end, page) async {
                      final api = await ApiClientInstance.getApiClient();
                      final res = await api.getPresCondsBetweenDates(
                        startDate: start.toIso8601String(),
                        endDate: end.toIso8601String(),
                        page: page,
                        perPage: 100,
                      );
                      final List<DataRepresentation> list = [];
                      for (var s in res.data) {
                        list.add(DataRepresentation(
                            name: strings.value.date,
                            code: "date",
                            source: s.toJson(),
                            transform: (dateString) {
                              final date = DateTime.parse(dateString);
                              return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year.toString().padLeft(2, "0")}   ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}.${date.millisecond}";
                            }));
                        if (linkedData.containsKey(s.date.toIso8601String())) {
                          linkedData[s.date.toIso8601String()]!.presCond = s;
                        } else {
                          linkedData[s.date.toIso8601String()] =
                              LinkedFiltrationData(
                            dateTime: s.date,
                            presCond: s,
                          );
                        }
                      }
                      final json_data = res.toJson();
                      json_data["data"] = list;
                      return json_data;
                    },
                  ),
                ],
              ),
            ).marginOnly(
              top: AppSizes.md,
            );
          },
        );
      },
    );
  }

  void showDataDialog(DataRepresentation<dynamic> d) {
    final strings = getTranslations(context);
    showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
            constraints: BoxConstraints(
              minWidth: min(context.width, 800),
              maxWidth: min(context.width, 800),
              minHeight: 400,
              maxHeight: 600,
            ),
            actions: [
              ShadButton.ghost(
                child: Text(strings.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ShadButton(
                child: Text(strings.visualize),
                onPressed: () {
                  Navigator.of(context).pop();
                  onTapListItem(d);
                },
              ),
            ],
            child: ShadTable.list(
                columnSpanExtent: (i) =>
                    FixedTableSpanExtent(min(context.width, 400)),
                header: [
                  ShadTableCell.header(
                      child: Text(
                    strings.name,
                  )),
                  ShadTableCell.header(
                      child: Text(
                    strings.value,
                  )),
                ],
                children: [
                  for (var e in d.source!.entries)
                    [
                      ShadTableCell(
                        child: Text(
                          e.key.toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      ShadTableCell(
                        child: Text(
                          e.value.toString(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ]
                ])).marginOnly(
          top: AppSizes.md,
        );
      },
    );
  }

  void onTapListItem(DataRepresentation<dynamic> d) {
    final strings = getTranslations(context).obs;

    logger.e("showing before: $year $month $day $hour $minute $second");
    final date = DateTime.parse(d.source!["date"]);

    final Niveau? _niveau = linkedData[date.toIso8601String()]?.niveau;
    final Debit? _debit = linkedData[date.toIso8601String()]?.debit;
    final Volume? _volume = linkedData[date.toIso8601String()]?.volume;
    final PresCond? _presCond = linkedData[date.toIso8601String()]?.presCond;

    printMessage("linkedData niveau: $_niveau");
    printMessage("linkedData debit: $_debit");
    printMessage("linkedData volume: $_volume");
    printMessage("linkedData presCond: $_presCond");

    if (_niveau == null) {
      logger.e("Niveau is null");
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.failedToGetNiveauData);
      return;
    } else if (_debit == null) {
      logger.e("Debit is null");
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.failedToGetDebitData);
      return;
    } else if (_volume == null) {
      logger.e("Volume is null");
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.failedToGetVolumeData);
      return;
    } else if (_presCond == null) {
      logger.e("PresCond is null");
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.failedToGetPresCondData);
      return;
    }
    Navigator.of(context).pop();

    niveau = _niveau;
    debit = _debit;
    volume = _volume;
    presCond = _presCond;

    year = date.year;
    month = date.month;
    day = date.day;
    hour = date.hour;
    minute = date.minute;
    second = date.second;
    logger.e("showing: $year $month $day $hour $minute $second");
    isLive.trigger(false);
  }

  _eauBrute() {
    final _somme = (niveau!.nivF1 ?? 0) + (niveau!.nivF2 ?? 0);
    final _pourcentage = (_somme * 100) / 900;
    final strings = getTranslations(context).obs;
    return Column(
      children: [
        Container(
          color: AppColors.lightGrey,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  strings.value.eauBrute,
                  style: Theme.of(getContext).textTheme.titleMedium,
                ).marginAll(AppSizes.sm),
                Text(
                  "${_somme.toStringAsFixed(2)} M3",
                  style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                        color: successColor,
                        fontWeight: FontWeight.bold,
                      ),
                ).marginAll(AppSizes.sm),
                Text(
                  "${_pourcentage.toStringAsFixed(2)} %",
                  style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                        color: successColor,
                        fontWeight: FontWeight.bold,
                      ),
                ).marginAll(AppSizes.sm),
              ],
            ),
          ),
        ),
        Wrap(
          children: [
            Cuve(
              title: "F1",
              okColor: successColor,
              dangerPoint: 50,
              value: F1_value,
              niveau1: niveau!.nivF1 ?? 0,
              niveau1Trailing: "M3",
              niveau2: F1_value,
              niveau2Trailing: "%",
            ),
            Cuve(
              title: "F2",
              okColor: successColor,
              dangerPoint: 50,
              value: F2_value,
              niveau1: niveau!.nivF2 ?? 0,
              niveau1Trailing: "M3",
              niveau2: F2_value,
              niveau2Trailing: "%",
            ),
          ],
        )
      ],
    );
  }

  _eauFiltrer() {
    final _somme = (niveau!.nivUf1 ?? 0) + (niveau!.nivUf2 ?? 0);
    final _pourcentage =
        ((niveau!.nivUf1 ?? 0) + (niveau!.nivUf2 ?? 0)) * 100 / 1040;
    final strings = getTranslations(context).obs;
    return Column(
      children: [
        Container(
          color: AppColors.lightGrey,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  strings.value.eauFiltrer,
                  style: Theme.of(getContext).textTheme.titleMedium,
                ).marginAll(AppSizes.sm),
                Text(
                  "${_somme.toStringAsFixed(2)} M3",
                  style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ).marginAll(AppSizes.sm),
                Text(
                  "${_pourcentage.toStringAsFixed(2)} %",
                  style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ).marginAll(AppSizes.sm),
              ],
            ),
          ),
        ),
        Wrap(
          children: [
            Cuve(
              title: "UF1",
              okColor: colorScheme.primary,
              dangerPoint: 50,
              value: UF1_value,
              niveau1: niveau!.nivUf1 ?? 0,
              niveau1Trailing: "M3",
              niveau2: UF1_value,
              niveau2Trailing: "%",
            ),
            Cuve(
              title: "UF2",
              okColor: colorScheme.primary,
              dangerPoint: 50,
              value: UF2_value,
              niveau1: niveau!.nivUf2 ?? 0,
              niveau1Trailing: "M3",
              niveau2: UF2_value,
              niveau2Trailing: "%",
            ),
          ],
        )
      ],
    );
  }

  _eauOsmosee() {
    final hytec_somme = (niveau!.nivOs1 ?? 0) +
        (niveau!.nivOs2 ?? 0) +
        (niveau!.nivOs3 ?? 0) +
        (niveau!.nivOs4 ?? 0);
    final osmotec_somme =
        (((niveau!.nivOs5 ?? 0) + (niveau!.nivOs6 ?? 0)) / 2) * 7;
    final strings = getTranslations(context).obs;
    return Column(
      children: [
        Container(
          color: AppColors.lightGrey,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  strings.value.eauOsmose,
                  style: Theme.of(getContext).textTheme.titleMedium,
                ).marginAll(AppSizes.sm),
                Text(
                  "${((hytec_somme + osmotec_somme)).toStringAsFixed(2)} M3",
                  style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ).marginAll(AppSizes.sm),
                Text(
                  "${(((hytec_somme + osmotec_somme)) * 100 / 675).toStringAsFixed(2)} %",
                  style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ).marginAll(AppSizes.sm),
              ],
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            ArrowElement(
              id: "hytec_outlet_usine_1",
              child: ArrowElement(
                id: "hytec",
                targetIds: ["data_hytec_osmotec", "data_outlet_usine_1"],
                sourceAnchor: Alignment.bottomCenter,
                targetAnchor: Alignment.topCenter,
                color: colorScheme.primaryContainer,
                straights: true,
                tipLength: 0,
                bow: 0,
                stretch: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: colorScheme.primaryContainer,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.lightGrey,
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Hytec",
                                style:
                                    Theme.of(getContext).textTheme.titleMedium,
                              ).marginAll(AppSizes.sm),
                              Text(
                                "${hytec_somme.toStringAsFixed(2)} M3",
                                style: Theme.of(getContext)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).marginAll(AppSizes.sm),
                              Text(
                                "${((hytec_somme) * 100 / 360).toStringAsFixed(2)} %",
                                style: Theme.of(getContext)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).marginAll(AppSizes.sm),
                            ],
                          ),
                        ),
                      ),
                      Wrap(children: [
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 1",
                          okColor: colorScheme.primaryContainer,
                          niveau1Trailing: "M3",
                          dangerPoint: 50,
                          value: OS1_value,
                          niveau1: niveau!.nivOs1 ?? 0,
                          niveau2: OS1_value,
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 2",
                          okColor: colorScheme.primaryContainer,
                          dangerPoint: 50,
                          value: OS2_value,
                          niveau1: niveau!.nivOs2 ?? 0,
                          niveau2: OS2_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 3",
                          okColor: colorScheme.primaryContainer,
                          dangerPoint: 50,
                          value: OS3_value,
                          niveau1: niveau!.nivOs3 ?? 0,
                          niveau2: OS3_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 4",
                          okColor: colorScheme.primaryContainer,
                          dangerPoint: 50,
                          value: OS4_value,
                          niveau1: (niveau!.nivOs4 ?? 0) / 3,
                          niveau2: OS4_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 5",
                          okColor: colorScheme.primaryContainer,
                          dangerPoint: 50,
                          value: OS4_value,
                          niveau1: (niveau!.nivOs4 ?? 0) / 3,
                          niveau2: OS4_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 6",
                          okColor: colorScheme.primaryContainer,
                          dangerPoint: 50,
                          value: OS4_value,
                          niveau1: (niveau!.nivOs4 ?? 0) / 3,
                          niveau2: OS4_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                      ]),
                    ],
                  ),
                ).marginAll(AppSizes.sm),
              ),
            ),
            SizedBox(
              height: AppSizes.lg,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ArrowElement(
                            id: "data_hytec_osmotec",
                            targetId: "osmotec",
                            sourceAnchor: Alignment.bottomCenter,
                            targetAnchor: Alignment.topCenter,
                            straights: true,
                            bow: 0,
                            stretch: 0,
                            color: colorScheme.primaryContainer,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(
                                    AppSizes.borderRadius),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSizes.sm),
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 200,
                                        maxWidth: 200,
                                      ),
                                      child: DividerWithText(
                                        text: "Débit",
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                    Text(
                                      "${(0).toStringAsFixed(2)} M3/H", // TODO: fix this
                                      style: Theme.of(getContext)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: colorScheme.onPrimary,
                                          ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 200,
                                        maxWidth: 200,
                                      ),
                                      child: DividerWithText(
                                        text: "Volume",
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                    Text(
                                      "${(0).toStringAsFixed(2)} M3",
                                      style: Theme.of(getContext)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: colorScheme.onPrimary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(children: [
                      ArrowElement(
                        id: "data_outlet_usine_1",
                        targetId: "outlet_usine_1",
                        sourceAnchor: Alignment.bottomCenter,
                        targetAnchor: Alignment.topCenter,
                        straights: true,
                        bow: 0,
                        stretch: 0,
                        color: colorScheme.primaryContainer,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.sm),
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 200,
                                    maxWidth: 200,
                                  ),
                                  child: DividerWithText(
                                    text: "Débit",
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "${(0).toStringAsFixed(2)} M3/H",
                                  style: Theme.of(getContext)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 200,
                                    maxWidth: 200,
                                  ),
                                  child: DividerWithText(
                                    text: "Volume",
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "${(0).toStringAsFixed(2)} M3",
                                  style: Theme.of(getContext)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 200,
                                    maxWidth: 200,
                                  ),
                                  child: DividerWithText(
                                    text: "Pression",
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "${(presCond!.pOse1 ?? 0).toStringAsFixed(2)} Bars",
                                  style: Theme.of(getContext)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 200,
                                    maxWidth: 200,
                                  ),
                                  child: DividerWithText(
                                    text: "Conductivité",
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "${(presCond!.cOse ?? 0).toStringAsFixed(2)} µs",
                                  style: Theme.of(getContext)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.xl),
                      ArrowElement(
                          id: "outlet_usine_1",
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                strings.value.usine,
                                style: Theme.of(getContext)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onPrimary,
                                    ),
                              ),
                            ),
                          ))
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSizes.lg,
            ),
            ArrowElement(
              id: "osmotec",
              targetId: "data_outlet_usine_2",
              sourceAnchor: Alignment.bottomCenter,
              targetAnchor: Alignment.topCenter,
              straights: true,
              bow: 0,
              stretch: 0,
              color: colorScheme.primaryContainer,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: colorScheme.primaryContainer,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      color: AppColors.lightGrey,
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "Osmotec",
                              style: Theme.of(getContext).textTheme.titleMedium,
                            ).marginAll(AppSizes.sm),
                            Text(
                              "${osmotec_somme.toStringAsFixed(2)} M3",
                              style: Theme.of(getContext)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ).marginAll(AppSizes.sm),
                            Text(
                              "${((osmotec_somme) * 100 / 315).toStringAsFixed(2)} %",
                              style: Theme.of(getContext)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ).marginAll(AppSizes.sm),
                          ],
                        ),
                      ),
                    ),
                    Wrap(children: [
                      Cuve(
                        title: "Osmotec 1",
                        okColor: colorScheme.secondary,
                        dangerPoint: 50,
                        value: OS5_value,
                        niveau1: niveau!.nivOs5 ?? 0,
                        niveau2: OS5_value,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 2",
                        okColor: colorScheme.secondary,
                        dangerPoint: 50,
                        value: OS5_value,
                        niveau1: niveau!.nivOs5 ?? 0,
                        niveau2: OS5_value,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 3",
                        okColor: colorScheme.secondary,
                        dangerPoint: 50,
                        value: OS5_value,
                        niveau1: niveau!.nivOs5 ?? 0,
                        niveau2: OS5_value,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                    ]),
                    Wrap(children: [
                      Cuve(
                        title: "Osmotec 4",
                        dangerPoint: 50,
                        value: OS6_value,
                        niveau1: niveau!.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 5",
                        dangerPoint: 50,
                        value: OS6_value,
                        niveau1: niveau!.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 6",
                        dangerPoint: 50,
                        value: OS6_value,
                        niveau1: niveau!.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 7",
                        dangerPoint: 50,
                        value: OS6_value,
                        niveau1: niveau!.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                    ]),
                  ],
                ),
              ).marginAll(AppSizes.sm),
            ),
            SizedBox(
              height: AppSizes.lg,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ArrowElement(
                        id: "data_outlet_usine_2",
                        targetId: "outlet_usine_2",
                        sourceAnchor: Alignment.bottomCenter,
                        targetAnchor: Alignment.topCenter,
                        straights: true,
                        bow: 0,
                        stretch: 0,
                        color: colorScheme.primaryContainer,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.sm),
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 200,
                                    maxWidth: 200,
                                  ),
                                  child: DividerWithText(
                                    text: "Pression",
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "${(presCond!.pOse2 ?? 0).toStringAsFixed(2)} Bars",
                                  style: Theme.of(getContext)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 200,
                                    maxWidth: 200,
                                  ),
                                  child: DividerWithText(
                                    text: "Conductivité",
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "${(presCond!.cOse ?? 0).toStringAsFixed(2)} µs",
                                  style: Theme.of(getContext)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.xl),
                      ArrowElement(
                          id: "outlet_usine_2",
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                strings.value.usine,
                                style: Theme.of(getContext)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onPrimary,
                                    ),
                              ),
                            ),
                          ))
                    ]),
              ],
            ),
            SizedBox(
              height: AppSizes.lg,
            ),
            Cuve(
              title: "Concentrat",
              dangerPoint: 50,
              okColor: colorScheme.primary,
              niveau1: 0,
              niveau2: 0,
              niveau1Trailing: "M3",
              niveau2Trailing: "%",
            ),
            Cuve(
              title: "Double Osmose Utilité",
              dangerPoint: 50,
              value: OS7_value,
              okColor: colorScheme.primary,
              niveau1: niveau!.nivOs7 ?? 0,
              niveau2: OS7_value,
              niveau1Trailing: "M3",
              niveau2Trailing: "%",
            ),
          ],
        )
      ],
    );
  }

  bool loading = false;
  int counter = 0;
  int blocked = 0;
  Future<void> load() async {
    counter++;
    if (loading) {
      blocked++;
      return;
    }
    loading = true;
    final strings = getTranslations(context);
    printMessage("load...");

    loaded.value = false;

    try {
      if (FiltrationPage.stream == null) {
        try {
          printMessage("connecting to filtration broadcast");
          FiltrationPage.channel = WebSocketChannel.connect(
              Uri.parse(ApiConfig.filtration_broadcast_websocket_url));
          final res = await (await ApiClientInstance.getApiClient())
              .getFiltrationMetaData();
          printMessage("filtration broadcast connected");
          feedMetaData = res;
          filtrationStartDate.value = res.startDate;
          filtrationEndDate.value = res.endDate;
          await FiltrationPage.channel!.ready;
          printMessage("filtration broadcast ready");
          FiltrationPage.stream =
              FiltrationPage.channel!.stream.asBroadcastStream();
          loaded.value = true;
          printMessage("filtration broadcast loaded");
        } catch (e) {
          printMessage("error connecting to filtration broadcast: $e");
          logger.e(
              "Error connecting to filtration broadcast${retries > 0 ? ',retrying' : ''}");
          if (retries > 0) {
            printMessage("retrying in 3 second");
            retries--;
            if (retries > 0) {
              Future.delayed(Duration(seconds: 3), load);
            }
          }
          Toasts.showErrorToastNotification(
              context: context,
              message: strings.failedToConnectToFiltrationBroadcast(retries));
        }
      } else {
        printMessage("Not Loading because Stream is not null");
      }
    } catch (e) {
      printMessage("loading faild: $e");
    } finally {
      loaded.value = true;
      loading = false;
    }
  }

  _dataRow({
    required String title,
    double? debit,
    double? volume,
    double? pression,
    bool bold = false,
    bool showDebit = true,
    bool showVolume = true,
    bool showPression = true,
  }) {
    return [
      ShadTableCell(
          child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: bold ? FontWeight.bold : null,
              color: colorScheme.onPrimary,
            ),
      )),
      if (showDebit)
        ShadTableCell(
          child: debit != null
              ? FittedBox(
                  child: Text(
                    "${debit!.toStringAsFixed(2)} M3/H",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: bold ? FontWeight.bold : null,
                          color: colorScheme.onPrimary,
                        ),
                  ),
                )
              : Container(),
        ),
      if (showVolume)
        ShadTableCell(
          child: volume != null
              ? FittedBox(
                  child: Text(
                    "${volume!.toStringAsFixed(2)} M3",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: bold ? FontWeight.bold : null,
                          color: colorScheme.onPrimary,
                        ),
                  ),
                )
              : Container(),
        ),
      if (showPression)
        ShadTableCell(
          child: pression != null
              ? FittedBox(
                  child: Text(
                    "${pression.toStringAsFixed(2)} Bars",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: bold ? FontWeight.bold : null,
                          color: colorScheme.onPrimary,
                        ),
                  ),
                )
              : Container(),
        ),
    ];
  }

  bool spaceIsNotEnough() {
    return sideMenuStateController.isOpen
        ? context.width <= 1500
        : context.width <= 1250;
  }
}

class LinkedFiltrationData {
  Niveau? niveau;
  PresCond? presCond;
  Volume? volume;
  Debit? debit;
  DateTime? dateTime;

  LinkedFiltrationData({
    this.dateTime,
    this.niveau,
    this.presCond,
    this.volume,
    this.debit,
  });
}
