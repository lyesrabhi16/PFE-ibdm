import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/cuve.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/models/debit.dart';
import 'package:ibdm/services/api_django/api_client/models/niveau.dart';
import 'package:ibdm/services/api_django/api_client/models/pres_cond.dart';
import 'package:ibdm/services/api_django/api_client/models/volume.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:widget_arrows/widget_arrows.dart';

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

  late final strings = getTranslations(getContext).obs;

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

  late Niveau niveau;
  late Debit debit;
  late Volume volume;
  late PresCond presCond;

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
  double get _somme_debit_forage => (debit.dF1 ?? 0) + (debit.dF2 ?? 0);
  double get _somme_debit_eau_brute =>
      (debit.dUf1 ?? 0) +
      (debit.dUf2 ?? 0) +
      (debit.dUf3 ?? 0) +
      (debit.dUf4 ?? 0) +
      (debit.dUf5 ?? 0) +
      (debit.dUf6 ?? 0);
  double get _somme_debit_eau_filtree_hytec =>
      (debit.dOs1 ?? 0) + (debit.dOs2 ?? 0) + (debit.dOs3 ?? 0);
  double get _somme_debit_eau_filtree_osmotec =>
      (debit.dOs4 ?? 0) +
      (debit.dOs5 ?? 0) +
      (debit.dOs6 ?? 0) +
      (debit.dOs8 ?? 0) +
      (debit.dOs9 ?? 0);
  double get _somme_volume_eau_brute =>
      (volume.volUf1 ?? 0) +
      (volume.volUf2 ?? 0) +
      (volume.volUf3 ?? 0) +
      (volume.volUf4 ?? 0) +
      (volume.volUf5 ?? 0) +
      (volume.volUf6 ?? 0);

  double get _somme_volume_eau_filtree_hytec =>
      (volume.volOs1 ?? 0) + (volume.volOs2 ?? 0) + (volume.volOs3 ?? 0);
  double get _somme_volume_eau_filtree_osmotec =>
      (volume.volOs4 ?? 0) +
      (volume.volOs5 ?? 0) +
      (volume.volOs6 ?? 0) +
      (volume.volOs8 ?? 0) +
      (volume.volOs9 ?? 0);
  double get _somme_volume_eau_filtree_osmosee =>
      _somme_volume_eau_filtree_hytec + _somme_volume_eau_filtree_osmotec;
  double get _somme_debit_eau_filtree_osmosee =>
      _somme_debit_eau_filtree_hytec + _somme_debit_eau_filtree_osmotec;
  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return AppCustomContainer(
        child: Padding(
      padding: EdgeInsets.all(AppSizes.sm),
      child: Obx(() {
        print("loaded: ${loaded.value}");
        if (!loaded.value) {
          print("loading because of loaded value");
          load();
          logger.e("loading because of loaded value");
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (refresh.value) {
          refresh.value = false;
        }
        try {
          return _build();
        } catch (e) {
          print("error: $e");
          FiltrationPage.channel?.sink.close();
          FiltrationPage.stream = null;
          load();
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    ));
  }

  StreamBuilder<dynamic> _build() {
    return StreamBuilder(
        stream: FiltrationPage.stream,
        builder: (context, snapshot) {
          //print("snapshot: $snapshot");
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting for connection");
            return Center(
              child: CircularProgressIndicator(),
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = JsonCodec().decode(snapshot.data);
          if (data["data"] == null || data["data"].isEmpty) {
            logger.e("data is null");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (isLive.value) {
            niveau = Niveau.fromJson(data["data"]["niveau"]);
            debit = Debit.fromJson(data["data"]["debit"]);
            volume = Volume.fromJson(data["data"]["volume"]);
            presCond = PresCond.fromJson(data["data"]["pres_cond"]);

            filtrationEndDate.value = niveau.date;
            year = niveau.date.year;
            month = niveau.date.month;
            day = niveau.date.day;
            hour = niveau.date.hour;
            minute = niveau.date.minute;
            second = niveau.date.second;
          }

          F1_value = (niveau.nivF1 ?? 0) * 100 / 450;
          F2_value = (niveau.nivF2 ?? 0) * 100 / 450;
          UF1_value = (niveau.nivUf1 ?? 0) * 100 / 520;
          UF2_value = (niveau.nivUf2 ?? 0) * 100 / 520;
          OS1_value = (niveau.nivOs1 ?? 0) * 100 / 60;
          OS2_value = (niveau.nivOs2 ?? 0) * 100 / 60;
          OS3_value = (niveau.nivOs3 ?? 0) * 100 / 60;
          OS4_value = (niveau.nivOs4 ?? 0) * 100 / 180;
          OS5_value = (niveau.nivOs5 ?? 0) * 100 / 45;
          OS6_value = (niveau.nivOs6 ?? 0) * 100 / 45;
          OS7_value = (niveau.nivOs7 ?? 0) * 100 / 10;
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
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: _getTopActionsBar(),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
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
                                    borderRadius: BorderRadius.circular(15),
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
                                              "F1 : ${(debit.dF1 ?? 0).toStringAsFixed(2)} M3/H",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color:
                                                        colorScheme.onPrimary,
                                                  ),
                                            ),
                                            Text(
                                              "F2 : ${(debit.dF2 ?? 0).toStringAsFixed(2)} M3/H",
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
                                              "${(volume.volFor ?? 0).toStringAsFixed(2)} M3",
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
                                      borderRadius: BorderRadius.circular(5),
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
                                    borderRadius: BorderRadius.circular(15),
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
                                                pression: (presCond.pUf ?? 0),
                                                bold: true),
                                            _dataRow(
                                              title: "UF1",
                                              debit: (debit.dUf1 ?? 0),
                                              volume: (volume.volUf1 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF2",
                                              debit: (debit.dUf2 ?? 0),
                                              volume: (volume.volUf2 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF3",
                                              debit: (debit.dUf3 ?? 0),
                                              volume: (volume.volUf3 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF4",
                                              debit: (debit.dUf4 ?? 0),
                                              volume: (volume.volUf4 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF5",
                                              debit: (debit.dUf5 ?? 0),
                                              volume: (volume.volUf5 ?? 0),
                                            ),
                                            _dataRow(
                                              title: "UF6",
                                              debit: (debit.dUf6 ?? 0),
                                              volume: (volume.volUf6 ?? 0),
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
                                      borderRadius: BorderRadius.circular(5),
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
                          ).removeWhen(isAtMostMediumScreen(context)),
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
                                    borderRadius: BorderRadius.circular(15),
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
                                          "F1 : ${(debit.dF1 ?? 0).toStringAsFixed(2)} M3/H",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.onPrimary,
                                              ),
                                        ),
                                        Text(
                                          "F2 : ${(debit.dF2 ?? 0).toStringAsFixed(2)} M3/H",
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
                                          "${(volume.volFor ?? 0).toStringAsFixed(2)} M3",
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
                                          "${(presCond.pUf ?? 0).toStringAsFixed(2)} Bars",
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
                                    borderRadius: BorderRadius.circular(5),
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
                                    borderRadius: BorderRadius.circular(15),
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
                                              pression: (presCond.pUf ?? 0),
                                              bold: true),
                                          _dataRow(
                                            title: "UF1",
                                            debit: (debit.dUf1 ?? 0),
                                            volume: (volume.volUf1 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF2",
                                            debit: (debit.dUf2 ?? 0),
                                            volume: (volume.volUf2 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF3",
                                            debit: (debit.dUf3 ?? 0),
                                            volume: (volume.volUf3 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF4",
                                            debit: (debit.dUf4 ?? 0),
                                            volume: (volume.volUf4 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF5",
                                            debit: (debit.dUf5 ?? 0),
                                            volume: (volume.volUf5 ?? 0),
                                          ),
                                          _dataRow(
                                            title: "UF6",
                                            debit: (debit.dUf6 ?? 0),
                                            volume: (volume.volUf6 ?? 0),
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
                                    borderRadius: BorderRadius.circular(5),
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
                          ).removeWhen(isAtLeastLargeScreen(context)),
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
                                  borderRadius: BorderRadius.circular(15),
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
                                                  debit: (debit.dOs1 ?? 0),
                                                  volume: (volume.volOs1 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS2",
                                                  debit: (debit.dOs2 ?? 0),
                                                  volume: (volume.volOs2 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS3",
                                                  debit: (debit.dOs3 ?? 0),
                                                  volume: (volume.volOs3 ?? 0),
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
                                                  debit: (debit.dOs4 ?? 0),
                                                  volume: (volume.volOs4 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS5",
                                                  debit: (debit.dOs5 ?? 0),
                                                  volume: (volume.volOs5 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS6",
                                                  debit: (debit.dOs6 ?? 0),
                                                  volume: (volume.volOs6 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS8",
                                                  debit: (debit.dOs8 ?? 0),
                                                  volume: (volume.volOs8 ?? 0),
                                                  showPression: false,
                                                ),
                                                _dataRow(
                                                  title: "OS9",
                                                  debit: (debit.dOs9 ?? 0),
                                                  volume: (volume.volOs9 ?? 0),
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
                                borderRadius: BorderRadius.circular(5),
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
                ),
              ),
            ],
          );
        });
  }

  _getFiltrationData() async {
    final _state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: getContext,
        messageSuccess: "data found",
        message: "getting data...",
        messageError: "data not found",
        state: _state);

    try {
      logger
          .e("Getting filtration data $year $month $day $hour $minute $second");
      final api = await ApiClientInstance.getApiClient();
      int done = 0;
      _setDone() {
        done++;
        if (done == 4) {
          refresh.value = true;
          _state.value = FutureState.success;
          loaded.value = true;
          Future.delayed(Durations.long2, () {
            toastification.dismissById(toast.id);
          });
        }
      }

      api
          .getNiveauAtSpecificTime(
            year: year!,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
          )
          .then((v) => {niveau = v, _setDone()});
      api
          .getDebitAtSpecificTime(
            year: year!,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
          )
          .then((v) => {debit = v, _setDone()});
      api
          .getVolumeAtSpecificTime(
            year: year!,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
          )
          .then((v) => {volume = v, _setDone()});
      api
          .getPresCondAtSpecificTime(
            year: year!,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
          )
          .then((v) => {presCond = v, _setDone()});
    } catch (e) {
      logger.e("Failed to get filtration data");
      _state.value = FutureState.error;
      loaded.value = true;
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
      return null;
    }
  }

  _getTopActionsBar() {
    return LiveDataTopActionBar(
      isLive: isLive,
      years: List.generate(
          filtrationEndDate.value.year - filtrationStartDate.value.year + 1,
          (index) => filtrationStartDate.value.year + index),
      months: List.generate(12, (index) => index + 1),
      days: List.generate(31, (index) => index + 1),
      hours: List.generate(24, (index) => index),
      minutes: List.generate(60, (index) => index),
      seconds: List.generate(60, (index) => index),
      yearInitialValue: filtrationEndDate.value.year,
      monthInitialValue: filtrationEndDate.value.month,
      dayInitialValue: filtrationEndDate.value.day,
      hourInitialValue: filtrationEndDate.value.hour,
      minuteInitialValue: filtrationEndDate.value.minute,
      secondInitialValue: filtrationEndDate.value.second,
      onYearChanged: (value) {
        year = value!;
        _getFiltrationData();
      },
      onMonthChanged: (value) {
        month = value;
        _getFiltrationData();
      },
      onDayChanged: (value) {
        day = value;
        _getFiltrationData();
      },
      onHourChanged: (value) {
        hour = value;
        _getFiltrationData();
      },
      onMinuteChanged: (value) {
        minute = value;
        _getFiltrationData();
      },
      onSecondChanged: (value) {
        second = value;
        _getFiltrationData();
      },
    );
  }

  _eauBrute() {
    final _somme = (niveau.nivF1 ?? 0) + (niveau.nivF2 ?? 0);
    final _pourcentage = (_somme * 100) / 900;

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
              value: F1_value,
              niveau1: niveau.nivF1 ?? 0,
              niveau1Trailing: "M3",
              niveau2: F1_value,
              niveau2Trailing: "%",
            ),
            Cuve(
              title: "F2",
              okColor: successColor,
              value: F2_value,
              niveau1: niveau.nivF2 ?? 0,
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
    final _somme = (niveau.nivUf1 ?? 0) + (niveau.nivUf2 ?? 0);
    final _pourcentage =
        ((niveau.nivUf1 ?? 0) + (niveau.nivUf2 ?? 0)) * 100 / 1040;
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
              value: UF1_value,
              niveau1: niveau.nivUf1 ?? 0,
              niveau1Trailing: "M3",
              niveau2: UF1_value,
              niveau2Trailing: "%",
            ),
            Cuve(
              title: "UF2",
              okColor: colorScheme.primary,
              value: UF2_value,
              niveau1: niveau.nivUf2 ?? 0,
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
    final hytec_somme = (niveau.nivOs1 ?? 0) +
        (niveau.nivOs2 ?? 0) +
        (niveau.nivOs3 ?? 0) +
        (niveau.nivOs4 ?? 0);
    final osmotec_somme =
        (((niveau.nivOs5 ?? 0) + (niveau.nivOs6 ?? 0)) / 2) * 7;
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
                          value: OS1_value,
                          niveau1: niveau.nivOs1 ?? 0,
                          niveau2: OS1_value,
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 2",
                          okColor: colorScheme.primaryContainer,
                          value: OS2_value,
                          niveau1: niveau.nivOs2 ?? 0,
                          niveau2: OS2_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 3",
                          okColor: colorScheme.primaryContainer,
                          value: OS3_value,
                          niveau1: niveau.nivOs3 ?? 0,
                          niveau2: OS3_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 4",
                          okColor: colorScheme.primaryContainer,
                          value: OS4_value,
                          niveau1: (niveau.nivOs4 ?? 0) / 3,
                          niveau2: OS4_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 5",
                          okColor: colorScheme.primaryContainer,
                          value: OS4_value,
                          niveau1: (niveau.nivOs4 ?? 0) / 3,
                          niveau2: OS4_value,
                          niveau1Trailing: "M3",
                          niveau2Trailing: "%",
                        ),
                        Cuve(
                          padding: AppSizes.sm + 1,
                          title: "Hytec 6",
                          okColor: colorScheme.primaryContainer,
                          value: OS4_value,
                          niveau1: (niveau.nivOs4 ?? 0) / 3,
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
                                borderRadius: BorderRadius.circular(15),
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
                                      "Not Found ${(0).toStringAsFixed(2)} M3/H", // TODO: fix this
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
                                      "Not Found ${(0).toStringAsFixed(2)} M3", // TODO: fix this
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
                            borderRadius: BorderRadius.circular(15),
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
                                  "Not Found ${(0).toStringAsFixed(2)} M3/H",
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
                                  "Not Found ${(0).toStringAsFixed(2)} M3",
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
                                  "${(presCond.pOse1 ?? 0).toStringAsFixed(2)} Bars",
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
                                  "${(presCond.cOse ?? 0).toStringAsFixed(2)} µs",
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
                                "USINE",
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
                        value: OS5_value,
                        niveau1: niveau.nivOs5 ?? 0,
                        niveau2: OS5_value,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 2",
                        okColor: colorScheme.secondary,
                        value: OS5_value,
                        niveau1: niveau.nivOs5 ?? 0,
                        niveau2: OS5_value,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 3",
                        okColor: colorScheme.secondary,
                        value: OS5_value,
                        niveau1: niveau.nivOs5 ?? 0,
                        niveau2: OS5_value,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                    ]),
                    Wrap(children: [
                      Cuve(
                        title: "Osmotec 4",
                        value: OS6_value,
                        niveau1: niveau.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 5",
                        value: OS6_value,
                        niveau1: niveau.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 6",
                        value: OS6_value,
                        niveau1: niveau.nivOs6 ?? 0,
                        niveau2: OS6_value,
                        okColor: colorScheme.primaryContainer,
                        niveau1Trailing: "M3",
                        niveau2Trailing: "%",
                      ),
                      Cuve(
                        title: "Osmotec 7",
                        value: OS6_value,
                        niveau1: niveau.nivOs6 ?? 0,
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
                            borderRadius: BorderRadius.circular(15),
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
                                  "${(presCond.pOse2 ?? 0).toStringAsFixed(2)} Bars",
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
                                  "${(presCond.cOse ?? 0).toStringAsFixed(2)} µs",
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
                                "USINE",
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
              niveau1Trailing: "M3",
              niveau2Trailing: "%",
            ),
            Cuve(
              title: "Double Osmose Utilité",
              value: OS7_value,
              okColor: colorScheme.primary,
              niveau1: niveau.nivOs7 ?? 0,
              niveau2: OS7_value,
              niveau1Trailing: "M3",
              niveau2Trailing: "%",
            ),
          ],
        )
      ],
    );
  }

  Future<void> load() async {
    print("load...");

    loaded.value = false;

    try {
      if (FiltrationPage.stream == null) {
        try {
          print("connecting to filtration broadcast");
          FiltrationPage.channel = WebSocketChannel.connect(
              Uri.parse(ApiConfig.filtration_broadcast_websocket_url));
          final res = await (await ApiClientInstance.getApiClient())
              .getFiltrationMetaData();
          print("filtration broadcast connected");
          filtrationStartDate.value = res.startDate;
          filtrationEndDate.value = res.endDate;
          await FiltrationPage.channel!.ready;
          print("filtration broadcast ready");
          FiltrationPage.stream =
              FiltrationPage.channel!.stream.asBroadcastStream();
          loaded.value = true;
          print("filtration broadcast loaded");
        } catch (e) {
          print("error connecting to filtration broadcast: $e");
          logger.e(
              "Error connecting to filtration broadcast${retries > 0 ? ',retrying' : ''}");
          if (retries > 0) {
            print("retrying in 1 second");
            retries--;
            Future.delayed(Duration(seconds: 1), load);
          } else {
            retries = 3;
          }
          Toasts.showErrorToastNotification(
              context: Get.context!,
              message:
                  "Failed To Connect To Filtration Broadcast${retries > 0 ? ',retrying' : ''}");
        }
      } else {
        print("Not Loading because Stream is not null");
      }
    } catch (e) {
      print("loading faild: $e");
    } finally {
      loaded.value = true;
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
                    "${debit.toStringAsFixed(2)} M3/H",
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
                    "${volume.toStringAsFixed(2)} M3",
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
}
