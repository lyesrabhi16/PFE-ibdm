import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/app_line_chart.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/cuve.dart';
import 'package:ibdm/common/widgets/cuve_with_radial_meter.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
import 'package:ibdm/common/widgets/multiple_data_lists.dart';
import 'package:ibdm/common/widgets/radial_meter.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/graphs.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CO2Page extends StatefulWidget {
  const CO2Page({super.key});

  static WebSocketChannel? channel;
  static Stream? stream;

  @override
  State<CO2Page> createState() => _CO2PageState();
}

class _CO2PageState extends State<CO2Page> {
  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  FeedMetaData? feedMetaData;

  final Rx<DateTime> co2StartDate = DateTime.now().obs;

  final Rx<DateTime> co2EndDate = DateTime.now().obs;

  final RxBool isLive = true.obs;

  int retries = 3;

  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;

  Co2Ifruit? co2_ifruit;
  final RxBool loaded = false.obs;
  final RxBool refresh = false.obs;

  Map<String, dynamic>? consommation;

  List<DataRepresentation> get _consommationDATA => [
        DataRepresentation(
            name: "182", code: "ut_co2_v182", source: consommation),
        DataRepresentation(
            name: "1833", code: "ut_co2_v1833", source: consommation),
        DataRepresentation(
            name: "CAN35", code: "ut_co2_vcan35", source: consommation),
        DataRepresentation(
            name: "KRV40", code: "ut_co2_vkrv40", source: consommation),
      ];
  List<DataRepresentation> get _entreeDATA => [
        DataRepresentation(
            name: "Entree", code: "ut_co2_ve", source: consommation),
      ];

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;

    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Obx(
          () {
            if (retries == 0) {
              return Center(
                child: Text(strings.value.failedToLoadData),
              );
            }

            printMessage("loaded: ${loaded.value}");
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
              CO2Page.channel?.sink.close();
              CO2Page.stream = null;
              load();
              return CircularProgressIndicatorWithText(
                text: strings.value.loading,
              );
            }
          },
        ),
      ),
    );
  }

  _registerData(Map<String, dynamic> data) {
    for (var e in data.entries) {
      _consommationDATA.forEach((d) {
        if (d.code == e.key) {
          d.source = data;
        }
      });
    }
  }

  Future<void> _loadConsommation() async {
    final strings = getTranslations(context);
    final now = DateTime.now();
    final toDate = DateTime(
      year ?? now.year,
      month ?? now.month,
      day ?? now.day,
    );
    final fromDate = toDate.previousDay;
    try {
      final api = await ApiClientInstance.getApiClient();
      final res = await api.getCo2IfruitConsommation(
        fromYear: fromDate.year,
        fromMonth: fromDate.month,
        fromDay: fromDate.day,
        toYear: toDate.year,
        toMonth: toDate.month,
        toDay: toDate.day,
      );
      consommation = res.toJson();
      logger.e(consommation);
    } catch (e) {
      logger.e(
          "failed to get Co2IfruitConsommation $fromDate => $toDate with error: $e");
      Toasts.showErrorToastNotification(
        context: context,
        message: strings.failedToGetConsommationData,
      );
    }
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
      if (CO2Page.stream == null) {
        try {
          printMessage("connecting to CO2 broadcast");
          CO2Page.channel = WebSocketChannel.connect(
              Uri.parse(ApiConfig.utilite_broadcast_websocket_url));
          final api = await ApiClientInstance.getApiClient();
          printMessage("CO2 broadcast connected");
          final results = await Future.wait([
            api.getFiltrationMetaData(),
            _loadConsommation(),
            CO2Page.channel!.ready,
          ]);
          feedMetaData = results[0] as FeedMetaData;
          co2StartDate.value = feedMetaData!.startDate;
          co2EndDate.value = feedMetaData!.endDate;
          printMessage("CO2 broadcast ready");
          CO2Page.stream = CO2Page.channel!.stream.asBroadcastStream();
          loaded.value = true;
          printMessage("CO2 broadcast loaded");
        } catch (e) {
          printMessage("error connecting to CO2 broadcast: $e");
          logger.e(
              "Error connecting to CO2 broadcast${retries > 0 ? ',retrying' : ''}");
          if (retries > 0) {
            printMessage("retrying in 3 second");
            retries--;
            if (retries > 0) {
              Future.delayed(Duration(seconds: 3), load);
            }
          }
          Toasts.showErrorToastNotification(
            context: context,
            message: strings.failedToConnectToCO2Broadcast(retries),
          );
        }
      } else {
        printMessage("Not Loading because Stream is null");
      }
    } catch (e) {
      printMessage("loading faild: $e");
    } finally {
      loaded.value = true;
      loading = false;
    }
  }

  Widget _build() {
    final strings = getTranslations(context).obs;
    return Obx(() {
      return Column(
        children: [
          Text(
            strings.value.co2Title,
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
                stream: CO2Page.stream,
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
                    if (CO2Page.channel?.closeCode != null ||
                        snapshot.connectionState != ConnectionState.active) {
                      logger.e("closing channel");
                      CO2Page.channel?.sink.close();
                      CO2Page.stream = null;
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
                    co2_ifruit = Co2Ifruit.fromJson(data["data"]["co2_ifruit"]);
                    _registerData(data["data"]["co2_ifruit"]);
                    Future.delayed(Duration(microseconds: 100),
                        () => co2EndDate.value = co2_ifruit!.date);
                    year = co2_ifruit!.date.year;
                    month = co2_ifruit!.date.month;
                    day = co2_ifruit!.date.day;
                    hour = co2_ifruit!.date.hour;
                    minute = co2_ifruit!.date.minute;
                    second = co2_ifruit!.date.second;
                  }

                  final CUVE_CO2_MGI_VALUE =
                      (co2_ifruit!.utCo2Vc1 ?? 0) * 100 / 36000;
                  final PRESSION_CO2_MGI_VALUE = (co2_ifruit!.utCo2Pc1 ?? 0);

                  final CUVE_CO2_CEVITAL_VALUE =
                      (co2_ifruit!.utCo2Vc2 ?? 0) * 100 / 60000;
                  final PRESSION_CO2_CEVITAL_VALUE =
                      (co2_ifruit!.utCo2Pc2 ?? 0);

                  final CUVE_N2_VALUE =
                      (co2_ifruit!.utN2Vn2 ?? 0) * 100 / 10000;
                  final PRESSION_N2_VALUE = (co2_ifruit!.utN2Vn2 ?? 0);

                  final PRESSION_SOUDE_VALUE = (co2_ifruit!.utSoude ?? 0);
                  final PRESSION_NOURISSE_VALUE = (co2_ifruit!.utCo2Pn ?? 0);

                  return Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                        maxWidth: context.width,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.borderRadius),
                          bottomRight: Radius.circular(AppSizes.borderRadius),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      if (isAtMostMediumScreen(context))
                                        SizedBox(
                                          width: context.width,
                                          child: Wrap(
                                            spacing: AppSizes.sm,
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              _entreeContainer(
                                                  context, strings),
                                              _consommationContainer(
                                                  context, strings),
                                            ],
                                          ),
                                        ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          CuveWithRadialMeter(
                                            cuve: Cuve(
                                              niveau1:
                                                  co2_ifruit!.utCo2Vc1 ?? 0,
                                              value: CUVE_CO2_MGI_VALUE,
                                              title: "",
                                              innerTitle: "CO2 MGI",
                                              niveau1Trailing: "KG",
                                              showNiveau2: false,
                                              dangerPoint: 55.5,
                                            ),
                                            radialMeter: RadialMeter(
                                              title: "CO2 MGI",
                                              value1Label: "",
                                              value1: PRESSION_CO2_MGI_VALUE,
                                              showTrack2: false,
                                              danger: 10,
                                              max: 20,
                                              steps: 2,
                                              value1Suffix: "Bars",
                                            ),
                                            title: "CO2 MGI",
                                          ),
                                          CuveWithRadialMeter(
                                            cuve: Cuve(
                                              niveau1:
                                                  co2_ifruit!.utCo2Vc2 ?? 0,
                                              value: CUVE_CO2_CEVITAL_VALUE,
                                              title: "",
                                              innerTitle: "CO2 CEVITAL",
                                              niveau1Trailing: "KG",
                                              showNiveau2: false,
                                              dangerPoint: 33.33,
                                            ),
                                            radialMeter: RadialMeter(
                                              title: "CO2 CEVITAL",
                                              value1Label: "",
                                              value1:
                                                  PRESSION_CO2_CEVITAL_VALUE,
                                              showTrack2: false,
                                              danger: 10,
                                              max: 20,
                                              steps: 2,
                                              value1Suffix: "Bars",
                                            ),
                                            title: "CO2 CEVITAL",
                                          ),
                                          CuveWithRadialMeter(
                                            cuve: Cuve(
                                              niveau1: co2_ifruit!.utN2Vn2 ?? 0,
                                              value: CUVE_N2_VALUE,
                                              title: "",
                                              innerTitle: "N2",
                                              niveau1Trailing: "KG",
                                              showNiveau2: false,
                                            ),
                                            radialMeter: RadialMeter(
                                              title: "N2",
                                              value1Label: "",
                                              value1: PRESSION_N2_VALUE,
                                              showTrack2: false,
                                              danger: 10,
                                              max: 20,
                                              steps: 2,
                                              value1Suffix: "Bars",
                                            ),
                                            title: "N2",
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        children: [
                                          CuveWithRadialMeter(
                                            title: "NOURISSE",
                                            radialMeter: RadialMeter(
                                              title: "NOURISSE",
                                              danger: 10,
                                              max: 20,
                                              value1Label: "",
                                              value1: PRESSION_NOURISSE_VALUE,
                                              showTrack2: false,
                                              steps: 2,
                                              value1Suffix: "Bars",
                                            ),
                                          ),
                                          CuveWithRadialMeter(
                                            title: "SOUDE",
                                            radialMeter: RadialMeter(
                                              title: "SOUDE",
                                              danger: 10,
                                              max: 20,
                                              value1Label: "",
                                              value1: PRESSION_SOUDE_VALUE,
                                              showTrack2: false,
                                              steps: 2,
                                              value1Suffix: "Bars",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isAtLeastLargeScreen(context))
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _entreeContainer(context, strings)
                                        ..marginSymmetric(
                                          horizontal: AppSizes.sm,
                                        ),
                                      SizedBox(height: AppSizes.lg),
                                      _consommationContainer(context, strings)
                                          .marginSymmetric(
                                        horizontal: AppSizes.sm,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }),
          ),
        ],
      );
    });
  }

  Container _entreeContainer(
      BuildContext context, Rx<AppLocalizations> strings) {
    return Container(
      constraints: BoxConstraints(
        minWidth: min(360, context.width),
        maxWidth: double.infinity,
        minHeight: min(100, context.width),
        maxHeight: double.infinity,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.value.entree,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppSizes.sm),
            SizedBox(
              width: min(360, context.width),
              height: 100,
              child: ShadTable.list(
                columnSpanExtent: (column) => column == 0
                    ? FixedTableSpanExtent(120)
                    : FixedTableSpanExtent(min(360, context.width) - 120),
                header: [
                  ShadTableCell.header(
                      child: Text(
                    strings.value.name.capitalize!,
                  )),
                  ShadTableCell.header(
                      alignment: Alignment.center,
                      child: Text(
                        strings.value.entree.capitalize!,
                      ))
                ],
                children: _entreeDATA.map(
                  (d) => [
                    ShadTableCell(child: Text(d.name.toUpperCase())),
                    ShadTableCell(
                      alignment: Alignment.center,
                      child: Text(
                          "${((d.value ?? 0) as double).toStringAsFixed(2)} KG"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _consommationContainer(
      BuildContext context, Rx<AppLocalizations> strings) {
    return Container(
      constraints: BoxConstraints(
        minWidth: min(360, context.width),
        maxWidth: double.infinity,
        minHeight: min(260, context.width),
        maxHeight: double.infinity,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.value.consommation,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppSizes.sm),
            SizedBox(
              width: min(360, context.width),
              height: 260,
              child: ShadTable.list(
                columnSpanExtent: (column) => column == 0
                    ? FixedTableSpanExtent(120)
                    : FixedTableSpanExtent(min(360, context.width) - 120),
                header: [
                  ShadTableCell.header(
                      child: Text(
                    strings.value.name.capitalize!,
                  )),
                  ShadTableCell.header(
                      alignment: Alignment.center,
                      child: Text(
                        strings.value.consommation.capitalize!,
                      ))
                ],
                children: _consommationDATA.map(
                  (d) => [
                    ShadTableCell(child: Text(d.name.toUpperCase())),
                    ShadTableCell(
                      alignment: Alignment.center,
                      child: Text(
                          ("${((d.value ?? 0) as double).toStringAsFixed(2)} KG")),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getCO2Data() async {
    final strings = getTranslations(context).obs;
    final _state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      context: getContext,
      messageSuccess: strings.value.dataFound,
      message: strings.value.retrievingData,
      messageError: strings.value.dataNotFound,
      state: _state,
    );

    try {
      logger.e("Getting CO2 data $year $month $day $hour $minute $second");
      final api = await ApiClientInstance.getApiClient();
      _setDone() {
        refresh.value = true;
        _state.value = FutureState.success;
        loaded.value = true;
        Future.delayed(Durations.long2, () {
          toastification.dismissById(toast.id);
        });
      }

      final res = await api.getCo2IfruitAtSpecificTime(
        year: year!,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
      );
      co2_ifruit = res;
      _setDone();
    } catch (e) {
      logger.e("Failed to get co2_ifruit data");
      _state.value = FutureState.error;
      loaded.value = true;
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
      return null;
    } finally {
      co2EndDate.value = co2_ifruit!.date;
      refresh.value = !refresh.value;
      logger.e("Set end Date $co2EndDate ${co2_ifruit!.date}");
    }
  }

  _getTopActionsBar() {
    final strings = getTranslations(context).obs;
    return Obx(() {
      //logger.e("selected: ${co2EndDate.value}");
      return LiveDataTopActionBar(
        isLive: isLive,
        startDate: feedMetaData!.startDate,
        endDate: feedMetaData!.endDate,
        selectedDate: isLive.value ? co2EndDate.value : co2_ifruit!.date,
        searchPressed: (dt) {
          year = dt.year;
          month = dt.month;
          day = dt.day;
          hour = dt.hour;
          minute = dt.minute;
          second = dt.second;
          _getCO2Data();
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
                        getGraphData: Graphs.getCO2NiveauGraphData,
                        ySuffix: " KG",
                      ),
                      GraphType(
                        name: "Pression",
                        getGraphData: Graphs.getCO2PressionGraphData,
                        ySuffix: " Bars",
                      ),
                      GraphType(
                        name: "Consommation",
                        supportsFetchType: false,
                        getGraphData: getConsommationGraphData,
                        ySuffix: " KG",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        listPressed: () {
          showShadDialog(
            context: context,
            builder: (context) {
              return ShadDialog(
                constraints: BoxConstraints(
                  minWidth: min(context.width, 600),
                  maxWidth: min(context.width, 800),
                ),
                child: MultipleDataLists(
                  tabs: [
                    DataListTab(
                      name: strings.value.co2,
                      onTap: showDataDialog,
                      getData: (start, end, page) async {
                        final api = await ApiClientInstance.getApiClient();
                        final res = await api.getCo2BetweenDates(
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
                        }
                        final json_data = res.toJson();
                        json_data["data"] = list;
                        return json_data;
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    });
  }

  Future<Map> getConsommationGraphData(
      DateTime startDate, DateTime endDate, FetchType? fetchType) async {
    final strings = getTranslations(getContext);
    Map data = {
      "182": [],
      "1833": [],
      "CAN35": [],
      "KRV40": [],
      "ENTREE": [],
    };

    final api = await ApiClientInstance.getApiClient();
    final res = await api.getCo2ConsommationBetweenDates(
      startDate: startDate.toIso8601String(),
      endDate: endDate.toIso8601String(),
    );
    for (var e in res.consommations) {
      if (data.containsKey("182")) {
        data["182"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utCo2V182 ?? 0,
        });
      }
      if (data.containsKey("1833")) {
        data["1833"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utCo2V1833 ?? 0,
        });
      }
      if (data.containsKey("CAN35")) {
        data["CAN35"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utCo2Vcan35 ?? 0,
        });
      }
      if (data.containsKey("KRV40")) {
        data["KRV40"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utCo2Vkrv40 ?? 0,
        });
      }
      if (data.containsKey("ENTREE")) {
        data["ENTREE"].add({
          "x": e.date.millisecondsSinceEpoch,
          "y": e.utCo2Ve ?? 0,
        });
      }
    }
    return data;
  }

  _openConsommationDialog() async {
    final strings = getTranslations(getContext).obs;
    Co2IfruitConsommation? cons;
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
            .getCo2IfruitConsommation(
          fromYear: _selectedDateRange.value.start.previousDay.year,
          fromMonth: _selectedDateRange.value.start.previousDay.month,
          fromDay: _selectedDateRange.value.start.previousDay.day,
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
            message: strings.value.failedToGetInventory,
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
            Row(
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
                      day.isSameDayOrGreatier(co2StartDate.value) &&
                      day.isSameDayOrLower(co2EndDate.value),
                  allowDeselection: false,
                  formatDateRange: (dateRange) =>
                      "${dateRange.start != null ? DateFormat("dd/MM/yyyy").format(dateRange.start!) : ''}${dateRange.end != null ? ' - ${DateFormat("dd/MM/yyyy").format(dateRange.end!)}' : ''}",
                  selected: ShadDateTimeRange(
                    start: _selectedDateRange.value.start,
                    end: _selectedDateRange.value.end,
                  ),
                  initialMonth: _selectedDateRange.value.start,
                  fromMonth: co2StartDate.value,
                  toMonth: co2EndDate.value,
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
                return Text(strings.value.failedToGetInventory);
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
                            [0, 1].contains(t)
                                ? 150
                                : context.width - (150 * 2)),
                        header: [
                          ShadTableCell.header(child: Text(strings.value.type)),
                          ShadTableCell.header(child: Text(strings.value.name)),
                          ShadTableCell.header(
                              child: Text(strings.value.value)),
                        ],
                        children: [
                          for (var r in [
                            DataRepresentation(
                                name: "",
                                code: "",
                                source: {},
                                extra: {"type": "entree"}),
                            DataRepresentation(
                                name: "Entree",
                                code: "ut_co2_ve",
                                source: cons?.toJson()),
                            DataRepresentation(
                                name: "",
                                code: "",
                                source: {},
                                extra: {"type": "consommation"}),
                            DataRepresentation(
                              name: "182",
                              code: "ut_co2_v182",
                              source: cons?.toJson(),
                            ),
                            DataRepresentation(
                              name: "1833",
                              code: "ut_co2_v1833",
                              source: cons?.toJson(),
                            ),
                            DataRepresentation(
                              name: "CAN35",
                              code: "ut_co2_vcan35",
                              source: cons?.toJson(),
                            ),
                            DataRepresentation(
                              name: "KRV40",
                              code: "ut_co2_vkrv40",
                              source: cons?.toJson(),
                            ),
                          ])
                            [
                              ShadTableCell(
                                child: Text(
                                  r.extra != null &&
                                          r.extra!.containsKey("type")
                                      ? r.extra!["type"].toString().capitalize!
                                      : "",
                                  softWrap: false,
                                ),
                              ),
                              ShadTableCell(
                                child: Text(
                                  r.name,
                                  softWrap: false,
                                ),
                              ),
                              ShadTableCell(
                                child: Text(
                                  (r.value ?? "").toString(),
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
      ),
    );
  }

  void onTapListItem(DataRepresentation<dynamic> d) {
    Navigator.of(context).pop();

    logger.e("showing before: $year $month $day $hour $minute $second");

    co2_ifruit = Co2Ifruit.fromJson(d.source!);

    year = co2_ifruit!.date.year;
    month = co2_ifruit!.date.month;
    day = co2_ifruit!.date.day;
    hour = co2_ifruit!.date.hour;
    minute = co2_ifruit!.date.minute;
    second = co2_ifruit!.date.second;
    logger.e("showing: $year $month $day $hour $minute $second");
    isLive.trigger(false);
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
                ]));
      },
    );
  }
}
