import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';

import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/cuve.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SiroperiePage extends StatefulWidget {
  const SiroperiePage({super.key});
  static WebSocketChannel? channel;
  static Stream? stream;

  @override
  State<SiroperiePage> createState() => _SiroperiePageState();
}

class _SiroperiePageState extends State<SiroperiePage> {
  @override
  void dispose() {
    logger.e("running dispose siroperie");
    SiroperiePage.channel?.sink.close();
    SiroperiePage.stream = null;
    super.dispose();
  }

  @override
  void deactivate() {
    logger.e("running deactivate siroperie");
    SiroperiePage.channel?.sink.close();
    SiroperiePage.stream = null;
    super.deactivate();
  }

  late FeedMetaData feedMetaDate;

  final Rx<bool> loaded = false.obs;

  double TS21_value = 80;

  double TS22_value = 50;

  double TS23_value = 20;

  double TS24_value = 21;

  double TS25_value = 0;

  double T02_value = 65;

  double T03_value = 100;

  double T04_value = 39;

  double T05_value = 15;

  double T06_value = 8;

  double sommeTetraL = 0;

  double get sommeTetraKG => convertSugarLToKG(sommeTetraL);

  double sommeAdueL = 0;

  double get sommeAdueKG => convertSugarLToKG(sommeAdueL);

  final Rx<DateTime> sucre_start_date = DateTime.now().obs;

  final Rx<DateTime> sucre_end_date = DateTime.now().obs;

  RxBool isLive = true.obs;

  double convertSugarLToKG(double inL) {
    return inL * 1.33;
  }

  int retries = 3;

  int? year;

  int? month;

  int? day;

  int? hour;

  int? minute;

  int? second;

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  _getSucreData() async {
    final strings = getTranslations(context);
    final _state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: getContext,
        messageSuccess: strings.dataFound,
        message: strings.retrievingData,
        messageError: strings.dataNotFound,
        state: _state);

    try {
      logger.e("Getting sucre data $year $month $day $hour $minute $second");
      final _sucre =
          await (await ApiClientInstance.getApiClient()).getSucreAtSpecificTime(
        year: year!,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
      );
      sucre = _sucre;

      refresh.value = true;
      _state.value = FutureState.success;
      loaded.value = true;
      return sucre;
    } catch (e) {
      logger.e("Failed to get sucre data");
      _state.value = FutureState.error;
      loaded.value = true;
      return null;
    } finally {
      sucre_end_date.value = sucre.date;
      refresh.value = !refresh.value;
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
    }
  }

  late Sucre sucre;

  Rx<bool> refresh = false.obs;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCustomContainer(
      child: Obx(
        () {
          printMessage("loaded: ${loaded.value}");
          if (!loaded.value) {
            printMessage("loading because of loaded value");
            _load();
            logger.e("loading because of loaded value");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (refresh.value) {
            refresh.value = false;
          }

          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Center(
                    child: Text(strings.value.siroperieTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                  ).marginAll(AppSizes.md),
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

                  // main view
                  Expanded(
                    child: StreamBuilder(
                      stream: SiroperiePage.stream,
                      builder: (context, snapshot) {
                        printMessage("snapshot: $snapshot");
                        if (isLive.value &&
                            (snapshot == null ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.data == null ||
                                snapshot.data == "" ||
                                JsonCodec().decode(snapshot.data) == null ||
                                JsonCodec().decode(snapshot.data)["data"] ==
                                    null)) {
                          printMessage("loading inside of stream builder");
                          if (snapshot.connectionState ==
                                  ConnectionState.none ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            printMessage("loading because of connection state");
                            _load();
                          }
                          logger.e("loading inside of stream builder");
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (isLive.value) {
                          sucre = Sucre.fromJson(
                              JsonCodec().decode(snapshot.data)["data"]);
                          Future.delayed(Duration(microseconds: 100),
                              () => sucre_end_date.value = sucre.date);
                          year = sucre.date.year;
                          month = sucre.date.month;
                          day = sucre.date.day;
                          hour = sucre.date.hour;
                          minute = sucre.date.minute;
                          second = sucre.date.second;
                        }

                        T02_value =
                            sucre.aT02 != null ? sucre.aT02! * 100 / 140000 : 0;
                        T03_value =
                            sucre.aT03 != null ? sucre.aT03! * 100 / 140000 : 0;
                        T04_value =
                            sucre.aT04 != null ? sucre.aT04! * 100 / 140000 : 0;
                        T05_value =
                            sucre.aT05 != null ? sucre.aT05! * 100 / 60000 : 0;
                        T06_value =
                            sucre.aT06 != null ? sucre.aT06! * 100 / 60000 : 0;
                        TS21_value =
                            sucre.tS21 != null ? sucre.tS21! * 100 / 60000 : 0;
                        TS22_value =
                            sucre.tS22 != null ? sucre.tS22! * 100 / 60000 : 0;
                        TS23_value =
                            sucre.tS23 != null ? sucre.tS23! * 100 / 60000 : 0;
                        TS24_value =
                            sucre.tS24 != null ? sucre.tS24! * 100 / 60000 : 0;
                        TS25_value =
                            sucre.tS25 != null ? sucre.tS25! * 100 / 60000 : 0;

                        sommeTetraL = (sucre.tS21 ?? 0) +
                            (sucre.tS22 ?? 0) +
                            (sucre.tS23 ?? 0) +
                            (sucre.tS24 ?? 0) +
                            (sucre.tS25 ?? 0);
                        sommeAdueL = (sucre.aT02 ?? 0) +
                            (sucre.aT03 ?? 0) +
                            (sucre.aT04 ?? 0) +
                            (sucre.aT05 ?? 0) +
                            (sucre.aT06 ?? 0);
                        return Container(
                          color: colorScheme.surfaceContainer,
                          width: context.width,
                          height: context.height / 2,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // sucre tetra
                                Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(strings.value.sucreTetraTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                )).marginAll(AppSizes.sm),
                                        _getBottomDataBarTetra(label: false),
                                      ],
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.spaceEvenly,
                                      children: [
                                        Cuve(
                                          title: "TS21",
                                          value: TS21_value,
                                          niveau1: sucre.tS21 ?? 0,
                                          niveau2: convertSugarLToKG(
                                              sucre.tS21 ?? 0),
                                        ),
                                        Cuve(
                                          title: "TS22",
                                          value: TS22_value,
                                          niveau1: sucre.tS22 ?? 0,
                                          niveau2: convertSugarLToKG(
                                              sucre.tS22 ?? 0),
                                        ),
                                        Cuve(
                                          title: "TS23",
                                          value: TS23_value,
                                          niveau1: sucre.tS23 ?? 0,
                                          niveau2: convertSugarLToKG(
                                              sucre.tS23 ?? 0),
                                        ),
                                        Cuve(
                                          title: "TS24",
                                          value: TS24_value,
                                          niveau1: sucre.tS24 ?? 0,
                                          niveau2: convertSugarLToKG(
                                              sucre.tS24 ?? 0),
                                        ),
                                        Cuve(
                                          title: "TS25",
                                          value: TS25_value,
                                          niveau1: sucre.tS25 ?? 0,
                                          niveau2: convertSugarLToKG(
                                              sucre.tS25 ?? 0),
                                        ),
                                      ],
                                    ),
                                    _getBottomDataBarTetra(),
                                  ],
                                ),

                                // sucre adue
                                Container(
                                  color: colorScheme.secondaryContainer,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        children: [
                                          Text(strings.value.sucreAdueTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  )).marginAll(AppSizes.sm),
                                          _getBottomDataBarAdue(label: false),
                                        ],
                                      ),
                                      Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          Cuve(
                                            title: "T02",
                                            value: T02_value,
                                            niveau1: sucre.aT02 ?? 0,
                                            niveau2: convertSugarLToKG(
                                                sucre.aT02 ?? 0),
                                          ),
                                          Cuve(
                                            title: "T03",
                                            value: T03_value,
                                            niveau1: sucre.aT03 ?? 0,
                                            niveau2: convertSugarLToKG(
                                                sucre.aT03 ?? 0),
                                          ),
                                          Cuve(
                                            title: "T04",
                                            value: T04_value,
                                            niveau1: sucre.aT04 ?? 0,
                                            niveau2: convertSugarLToKG(
                                                sucre.aT04 ?? 0),
                                          ),
                                          Cuve(
                                            title: "T05",
                                            value: T05_value,
                                            niveau1: sucre.aT05 ?? 0,
                                            niveau2: convertSugarLToKG(
                                                sucre.aT05 ?? 0),
                                          ),
                                          Cuve(
                                            title: "T06",
                                            value: T06_value,
                                            niveau1: sucre.aT06 ?? 0,
                                            niveau2: convertSugarLToKG(
                                                sucre.aT06 ?? 0),
                                          ),
                                        ],
                                      ),
                                      _getBottomDataBarAdue(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: context.width,
                    decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.borderRadius),
                          bottomRight: Radius.circular(AppSizes.borderRadius),
                        )),
                    child: _getBottomDataBar(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _load() async {
    final strings = getTranslations(context);
    printMessage("siroperie page loading");
    loaded.value = false;
    if (SiroperiePage.stream == null) {
      try {
        printMessage("connecting to sucre broadcast");
        SiroperiePage.channel = WebSocketChannel.connect(
            Uri.parse(ApiConfig.sucre_broadcast_websocket_url));
        final res =
            await (await ApiClientInstance.getApiClient()).getSucreMetaData();
        printMessage("sucre broadcast connected");
        sucre_start_date.value = res.startDate;
        sucre_end_date.value = res.endDate;
        await SiroperiePage.channel!.ready;
        printMessage("sucre broadcast ready");
        SiroperiePage.stream =
            SiroperiePage.channel!.stream.asBroadcastStream();
        loaded.value = true;
        printMessage("sucre broadcast loaded");
      } catch (e) {
        printMessage("error connecting to sucre broadcast: $e");
        logger.e(
            "Error connecting to sucre broadcast${retries > 0 ? ',retrying' : ''}");
        if (retries > 0) {
          printMessage("retrying in 1 second");
          retries--;
          Future.delayed(Duration(seconds: 1), _load);
        } else {
          retries = 3;
        }
        Toasts.showErrorToastNotification(
            context: context,
            message: strings.failedToConnectToSiroperieBroadcast(retries));
      }
    }
    loaded.value = true;
  }

  _getTopActionsBar() {
    final strings = getTranslations(getContext).obs;
    return LiveDataTopActionBar(
      isLive: isLive,
      startDate: feedMetaDate.startDate,
      endDate: feedMetaDate.endDate,
      selectedDate: sucre_end_date.value,
      searchPressed: (dt) {
        year = dt.year;
        month = dt.month;
        day = dt.day;
        hour = dt.hour;
        minute = dt.minute;
        second = dt.second;
        _getSucreData();
      },
      afterDataDisplayWidgets: [
        // inventory button
        ShadButton(
          onPressed: () => _openInventoryDialog(),
          child: Text(strings.value.inventory),
        )
      ],
    );
  }

  _getBottomDataBar() {
    final strings = getTranslations(getContext).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(getContext).colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.sm),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  Text(
                    strings.value.totalSucre,
                    style: Theme.of(getContext).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(getContext).colorScheme.onPrimary,
                        ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(width: AppSizes.lg)
                          .removeWhen(isAtLeastMediumScreen(getContext)),
                      Text(
                        " ${(sommeTetraL + sommeAdueL).toStringAsFixed(2)} L",
                        style:
                            Theme.of(getContext).textTheme.titleLarge?.copyWith(
                                  color: (sommeTetraL + sommeAdueL) < 84000
                                      ? errorColor
                                      : successColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(width: AppSizes.lg),
                      Text(
                        " ${(sommeTetraKG + sommeAdueKG).toStringAsFixed(2)} KG",
                        style: Theme.of(getContext)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: (sommeTetraKG + sommeAdueKG) < (84000 * 3)
                                  ? errorColor
                                  : successColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ].nonNulls.toList(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _getBottomDataBarTetra({bool label = true}) {
    final strings = getTranslations(getContext).obs;
    return Container(
      constraints: BoxConstraints(
        maxWidth: context.width,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.sm),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            if (label)
              Obx(() {
                return Text(strings.value.totalSucreTetra,
                    style: Theme.of(getContext).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ));
              }),
            Text(
              " ${sommeTetraL.toStringAsFixed(2)} L",
              softWrap: false,
              style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                    color: sommeTetraL < 30000 ? errorColor : successColor,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            Text(
              ",",
              style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              " ${sommeTetraKG.toStringAsFixed(2)} KG",
              softWrap: false,
              style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                    color: sommeTetraKG < 30000 * 3 ? errorColor : successColor,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _getBottomDataBarAdue({bool label = true}) {
    final strings = getTranslations(getContext).obs;
    return Padding(
      padding: EdgeInsets.all(AppSizes.sm),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          if (label)
            Obx(() {
              return Text(strings.value.totalSucreAdue,
                  style: Theme.of(getContext).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ));
            }),
          Text(
            " ${sommeAdueL.toStringAsFixed(2)} L",
            softWrap: false,
            style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                  color: sommeAdueL < 54000 ? errorColor : successColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
          Text(
            ",",
            style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            " ${sommeAdueKG.toStringAsFixed(2)} KG",
            softWrap: false,
            style: Theme.of(getContext).textTheme.titleMedium?.copyWith(
                  color: sommeAdueKG < 54000 * 3 ? errorColor : successColor,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  _openInventoryDialog() async {
    final strings = getTranslations(getContext).obs;
    Sucre? sucre;

    final Rx<DateTime> _selectedDate = DateTime.now().obs;
    final Rx<bool> _dataLoaded = false.obs;
    final Rx<bool> _failed = false.obs;
    int retries = 3;
    _getSucreData() async {
      _dataLoaded.value = false;

      try {
        sucre = await (await ApiClientInstance.getApiClient())
            .getSucreAtSpecificTime(
          year: _selectedDate.value.year,
          month: _selectedDate.value.month,
          day: _selectedDate.value.day,
        );
        _failed.value = false;
        _dataLoaded.value = true;
      } catch (e) {
        if (retries > 0) {
          retries--;
          _getSucreData();
        } else {
          retries = 3;

          _failed.value = true;
          _dataLoaded.value = true;
          Toasts.showErrorToast(
            context: getContext,
            message: strings.value.failedToGetInventory,
          );
        }
      }
    }

    return showShadDialog(
      context: getContext,
      builder: (context) => ShadDialog(
        title: Text(
          strings.value.inventory,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        description: Text(strings.value.inventoryDescription),
        child: Column(
          children: [
            ShadDatePicker(
              onChanged: (value) => {
                _selectedDate.value = value ?? _selectedDate.value,
                _getSucreData()
              },
              closeOnSelection: true,
              closeOnTapOutside: true,
              selectableDayPredicate: (day) =>
                  day.isSameDayOrGreatier(sucre_start_date.value) &&
                  day.isSameDayOrLower(sucre_end_date.value),
              allowDeselection: false,
              formatDate: (date) => "${date.day}/${date.month}/${date.year}",
              selected: _selectedDate.value,
              initialMonth: _selectedDate.value,
              fromMonth: sucre_start_date.value,
              toMonth: sucre_end_date.value,
            ),
            Obx(() {
              if (!_dataLoaded.value) {
                _getSucreData();
                return SizedBox(
                  height: 600,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (_failed.value) {
                return Text(strings.value.failedToGetInventory);
              }
              double _T02_value =
                  sucre?.aT02 != null ? sucre!.aT02! * 100 / 140000 : 0;
              double _T03_value =
                  sucre?.aT03 != null ? sucre!.aT03! * 100 / 140000 : 0;
              double _T04_value =
                  sucre?.aT04 != null ? sucre!.aT04! * 100 / 140000 : 0;
              double _T05_value =
                  sucre?.aT05 != null ? sucre!.aT05! * 100 / 60000 : 0;
              double _T06_value =
                  sucre?.aT06 != null ? sucre!.aT06! * 100 / 60000 : 0;
              double _TS21_value =
                  sucre?.tS21 != null ? sucre!.tS21! * 100 / 60000 : 0;
              double _TS22_value =
                  sucre?.tS22 != null ? sucre!.tS22! * 100 / 60000 : 0;
              double _TS23_value =
                  sucre?.tS23 != null ? sucre!.tS23! * 100 / 60000 : 0;
              double _TS24_value =
                  sucre?.tS24 != null ? sucre!.tS24! * 100 / 60000 : 0;
              double _TS25_value =
                  sucre?.tS25 != null ? sucre!.tS25! * 100 / 60000 : 0;
              double _sommeTetraL = (sucre?.tS21 ?? 0) +
                  (sucre?.tS22 ?? 0) +
                  (sucre?.tS23 ?? 0) +
                  (sucre?.tS24 ?? 0) +
                  (sucre?.tS25 ?? 0);
              double _sommeAdueL = (sucre?.aT02 ?? 0) +
                  (sucre?.aT03 ?? 0) +
                  (sucre?.aT04 ?? 0) +
                  (sucre?.aT05 ?? 0) +
                  (sucre?.aT06 ?? 0);
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
                        columnSpanExtent: (t) => FixedTableSpanExtent(130),
                        rowSpanBackgroundDecoration: (row) =>
                            [6, 12, 13].contains(row)
                                ? SpanDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer)
                                : null,
                        header: [
                          ShadTableCell.header(child: Text(strings.value.cuve)),
                          ShadTableCell.header(
                              child: Text(strings.value.levelInL)),
                          ShadTableCell.header(
                              child: Text(strings.value.levelInKG)),
                          ShadTableCell.header(
                              child: Text(strings.value.fillLevel)),
                        ],
                        children: [
                          for (var r in [
                            InventoryRow(
                              nom: "TS21",
                              niveauL:
                                  "${sucre!.tS21?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.tS21 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_TS21_value.toStringAsFixed(2)}%",
                              inDanger: _TS21_value < 10,
                            ),
                            InventoryRow(
                              nom: "TS22",
                              niveauL:
                                  "${sucre!.tS22?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.tS22 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_TS22_value.toStringAsFixed(2)}%",
                              inDanger: _TS22_value < 10,
                            ),
                            InventoryRow(
                              nom: "TS23",
                              niveauL:
                                  "${sucre!.tS23?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.tS23 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_TS23_value.toStringAsFixed(2)}%",
                              inDanger: _TS23_value < 10,
                            ),
                            InventoryRow(
                              nom: "TS24",
                              niveauL:
                                  "${sucre!.tS24?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.tS24 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_TS24_value.toStringAsFixed(2)}%",
                              inDanger: _TS24_value < 10,
                            ),
                            InventoryRow(
                              nom: "TS25",
                              niveauL:
                                  "${sucre!.tS25?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.tS25 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_TS25_value.toStringAsFixed(2)}%",
                              inDanger: _TS25_value < 10,
                            ),
                            InventoryRow(
                              nom: "Total Tetra",
                              niveauL: "${_sommeTetraL.toStringAsFixed(2)} L",
                              niveauKG:
                                  "${convertSugarLToKG(_sommeTetraL).toStringAsFixed(2)} KG",
                              fill:
                                  "${(_sommeTetraL * 100 / 300000).toStringAsFixed(2)}%",
                              inDanger: _sommeTetraL < 30000,
                            ),
                            InventoryRow(
                              nom: "T02",
                              niveauL:
                                  "${sucre!.aT02?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.aT02 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_T02_value.toStringAsFixed(2)}%",
                              inDanger: _T02_value < 10,
                            ),
                            InventoryRow(
                              nom: "T03",
                              niveauL:
                                  "${sucre!.aT03?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.aT03 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_T03_value.toStringAsFixed(2)}%",
                              inDanger: _T03_value < 10,
                            ),
                            InventoryRow(
                              nom: "T04",
                              niveauL:
                                  "${sucre!.aT04?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.aT04 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_T04_value.toStringAsFixed(2)}%",
                              inDanger: _T04_value < 10,
                            ),
                            InventoryRow(
                              nom: "T05",
                              niveauL:
                                  "${sucre!.aT05?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.aT05 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_T05_value.toStringAsFixed(2)}%",
                              inDanger: _T05_value < 10,
                            ),
                            InventoryRow(
                              nom: "T06",
                              niveauL:
                                  "${sucre!.aT06?.toStringAsFixed(2) ?? 0} L",
                              niveauKG:
                                  "${convertSugarLToKG(sucre!.aT06 ?? 0).toStringAsFixed(2)} KG",
                              fill: "${_T06_value.toStringAsFixed(2)}%",
                              inDanger: _T06_value < 10,
                            ),
                            InventoryRow(
                              nom: "Total Adue",
                              niveauL: "${_sommeAdueL.toStringAsFixed(2)} L",
                              niveauKG:
                                  "${convertSugarLToKG(_sommeAdueL).toStringAsFixed(2)} KG",
                              fill:
                                  "${(_sommeAdueL * 100 / 540000).toStringAsFixed(2)}%",
                              inDanger: _sommeAdueL < 54000,
                            ),
                            InventoryRow(
                              nom: "Total",
                              niveauL:
                                  "${(_sommeTetraL + _sommeAdueL).toStringAsFixed(2)} L",
                              niveauKG:
                                  "${convertSugarLToKG((_sommeTetraL + _sommeAdueL)).toStringAsFixed(2)} KG",
                              fill:
                                  "${((_sommeTetraL + _sommeAdueL) * 100 / 840000).toStringAsFixed(2)}%",
                              inDanger: (_sommeTetraL + _sommeAdueL) < 84000,
                            ),
                          ])
                            [
                              ShadTableCell(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: r.inDanger
                                          ? errorColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                child: Text(
                                  r.nom,
                                  softWrap: false,
                                ),
                              ),
                              ShadTableCell(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: r.inDanger
                                          ? errorColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                child: Text(
                                  r.niveauL,
                                  softWrap: false,
                                ),
                              ),
                              ShadTableCell(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: r.inDanger
                                          ? errorColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                child: Text(
                                  r.niveauKG,
                                  softWrap: false,
                                ),
                              ),
                              ShadTableCell(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: r.inDanger
                                          ? errorColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                child: Text(
                                  r.fill,
                                  softWrap: false,
                                ),
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                        Text(
                          strings.value.toOrder,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: errorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          "${((840000 - (_sommeTetraL + _sommeAdueL)) / 20000).floor()} ${strings.value.tank(((840000 - (_sommeTetraL + _sommeAdueL)) / 20000).floor())}",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: errorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ]))
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

class InventoryRow {
  final String nom;
  final String niveauL;
  final String niveauKG;
  final String fill;
  final bool inDanger;
  InventoryRow({
    required this.nom,
    required this.niveauL,
    required this.niveauKG,
    required this.fill,
    required this.inDanger,
  });
}
