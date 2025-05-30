import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/app_line_chart.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
import 'package:ibdm/common/widgets/multiple_data_lists.dart';
import 'package:ibdm/common/widgets/radial_meter.dart';
import 'package:ibdm/common/widgets/temp_gauge.dart';
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
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UtilitePage extends StatefulWidget {
  const UtilitePage({super.key});

  static WebSocketChannel? channel;
  static Stream? stream;

  @override
  State<UtilitePage> createState() => _UtilitePageState();
}

class _UtilitePageState extends State<UtilitePage> {
  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  FeedMetaData? feedMetaData;

  final Rx<DateTime> utiliteStartDate = DateTime.now().obs;

  final Rx<DateTime> utiliteEndDate = DateTime.now().obs;

  final RxBool isLive = true.obs;

  int retries = 3;

  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;

  Utilite? utilite;

  final RxBool loaded = false.obs;
  final RxBool refresh = false.obs;

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
              UtilitePage.channel?.sink.close();
              UtilitePage.stream = null;
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
      if (UtilitePage.stream == null) {
        try {
          printMessage("connecting to utilite broadcast");
          UtilitePage.channel = WebSocketChannel.connect(
              Uri.parse(ApiConfig.utilite_broadcast_websocket_url));
          final res = await (await ApiClientInstance.getApiClient())
              .getUtiliteMetaData();
          printMessage("utilite broadcast connected");
          feedMetaData = res;
          utiliteStartDate.value = res.startDate;
          utiliteEndDate.value = res.endDate;
          await UtilitePage.channel!.ready;
          printMessage("utilite broadcast ready");
          UtilitePage.stream = UtilitePage.channel!.stream.asBroadcastStream();
          loaded.value = true;
          printMessage("utilite broadcast loaded");
        } catch (e) {
          printMessage("error connecting to utilite broadcast: $e");
          logger.e(
              "Error connecting to utilite broadcast${retries > 0 ? ',retrying' : ''}");
          if (retries > 0) {
            printMessage("retrying in 1 second");
            retries--;
            if (retries > 0) {
              Future.delayed(Duration(seconds: 3), load);
            }
          }
          Toasts.showErrorToastNotification(
            context: context,
            message: strings.failedToConnectToUtiliteBroadcast(retries),
          );
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

  Widget _build() {
    final strings = getTranslations(context).obs;
    return Obx(() {
      return Column(
        children: [
          Text(
            strings.value.utiliteTitle,
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
                stream: UtilitePage.stream,
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
                    if (UtilitePage.channel?.closeCode != null ||
                        snapshot.connectionState != ConnectionState.active) {
                      logger.e("closing channel");
                      UtilitePage.channel?.sink.close();
                      UtilitePage.stream = null;
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
                    utilite = Utilite.fromJson(data["data"]["utilite"]);

                    Future.delayed(Duration(microseconds: 100),
                        () => utiliteEndDate.value = utilite!.date);
                    year = utilite!.date.year;
                    month = utilite!.date.month;
                    day = utilite!.date.day;
                    hour = utilite!.date.hour;
                    minute = utilite!.date.minute;
                    second = utilite!.date.second;
                  }
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
                            Wrap(
                              children: [
                                TempGauge(
                                  title: "Temperature Trane",
                                  value1: utilite!.utKrTt ?? 0,
                                  value2: utilite!.utSidTt ?? 0,
                                  start: 0,
                                  end: 10,
                                  dangerTempHigh: 5,
                                  steps: 1,
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                TempGauge(
                                  title: "Temperature Compresseur",
                                  value1: utilite!.utKrTc ?? 0,
                                  value2: utilite!.utSidTc ?? 0,
                                  start: 0,
                                  end: 40,
                                  dangerTempHigh: 35,
                                  steps: 5,
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                              ],
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                RadialMeter(
                                  value1: utilite!.utKrP7 ?? 0,
                                  value2: utilite!.utSidP7 ?? 0,
                                  max: 10,
                                  danger: 6.5,
                                  title: "Pression 7",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite!.utKrP40 ?? 0,
                                  value2: utilite!.utSidP40 ?? 0,
                                  max: 40,
                                  steps: 5,
                                  danger: 26,
                                  title: "Pression 40",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite!.utKrPn2 ?? 0,
                                  value2: utilite!.utSidPn2 ?? 0,
                                  max: 10,
                                  danger: 6.5,
                                  title: "Pression Azote",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite!.utKrPv ?? 0,
                                  value2: utilite!.utSidPv ?? 0,
                                  max: 10,
                                  danger: 6.5,
                                  title: "Pression Chaudiere",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite!.utKrPg ?? 0,
                                  value2: utilite!.utSidPg ?? 0,
                                  max: 300,
                                  steps: 50,
                                  danger: 250,
                                  title: "Pression Gaz",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
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

  _getUtiliteData() async {
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
      logger.e("Getting Utilite data $year $month $day $hour $minute $second");
      final api = await ApiClientInstance.getApiClient();
      int done = 0;
      _setDone() {
        refresh.value = true;
        _state.value = FutureState.success;
        loaded.value = true;
        Future.delayed(Durations.long2, () {
          toastification.dismissById(toast.id);
        });
      }

      final res = await api.getUtiliteAtSpecificTime(
        year: year!,
        month: month,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
      );
      utilite = res;
      _setDone();
    } catch (e) {
      logger.e("Failed to get Utilite data");
      _state.value = FutureState.error;
      loaded.value = true;
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
      return null;
    } finally {
      utiliteEndDate.value = utilite!.date;
      refresh.value = !refresh.value;
    }
  }

  _getTopActionsBar() {
    final strings = getTranslations(context).obs;
    return Obx(() {
      return LiveDataTopActionBar(
        isLive: isLive,
        startDate: feedMetaData!.startDate,
        endDate: feedMetaData!.endDate,
        selectedDate: isLive.value ? utiliteEndDate.value : utilite!.date,
        searchPressed: (dt) {
          year = dt.year;
          month = dt.month;
          day = dt.day;
          hour = dt.hour;
          minute = dt.minute;
          second = dt.second;
          _getUtiliteData();
        },
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
                        name: "Temperature",
                        getGraphData: Graphs.getUtiliteTempGraphData,
                        ySuffix: " °C",
                      ),
                      GraphType(
                        name: "Temperature Trane",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtiliteTempGraphData(
                                start, end, fetchType,
                                inludeTrane: true, includeCompresseur: false),
                        ySuffix: " °C",
                      ),
                      GraphType(
                        name: "Temperature Compresseur",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtiliteTempGraphData(
                                start, end, fetchType,
                                inludeTrane: false, includeCompresseur: true),
                        ySuffix: " °C",
                      ),
                      GraphType(
                        name: "Pression",
                        getGraphData: Graphs.getUtilitePressionGraphData,
                        ySuffix: " Bars",
                      ),
                      GraphType(
                        name: "Pression 7",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtilitePressionGraphData(
                                start, end, fetchType,
                                includePression7: true,
                                includePression40: false,
                                includePressionAzote: false,
                                includePressionChaudiere: false,
                                includePressionGaz: false),
                        ySuffix: " Bars",
                      ),
                      GraphType(
                        name: "Pression 40",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtilitePressionGraphData(
                                start, end, fetchType,
                                includePression7: false,
                                includePression40: true,
                                includePressionAzote: false,
                                includePressionChaudiere: false,
                                includePressionGaz: false),
                        ySuffix: " Bars",
                      ),
                      GraphType(
                        name: "Pression Azote",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtilitePressionGraphData(
                                start, end, fetchType,
                                includePression7: false,
                                includePression40: false,
                                includePressionAzote: true,
                                includePressionChaudiere: false,
                                includePressionGaz: false),
                        ySuffix: " Bars",
                      ),
                      GraphType(
                        name: "Pression Chaudiere",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtilitePressionGraphData(
                                start, end, fetchType,
                                includePression7: false,
                                includePression40: false,
                                includePressionAzote: false,
                                includePressionChaudiere: true,
                                includePressionGaz: false),
                        ySuffix: " Bars",
                      ),
                      GraphType(
                        name: "Pression Gaz",
                        getGraphData: (start, end, fetchType) =>
                            Graphs.getUtilitePressionGraphData(
                                start, end, fetchType,
                                includePression7: false,
                                includePression40: false,
                                includePressionAzote: false,
                                includePressionChaudiere: false,
                                includePressionGaz: true),
                        ySuffix: " Bars",
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
                      name: strings.value.utilite,
                      onTap: showDataDialog,
                      getData: (start, end, page) async {
                        final api = await ApiClientInstance.getApiClient();
                        final res = await api.getUtiliteBetweenDates(
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
              ).marginOnly(
                top: AppSizes.md,
              );
            },
          );
        },
      );
    });
  }

  void onTapListItem(DataRepresentation<dynamic> d) {
    Navigator.of(context).pop();

    logger.e("showing before: $year $month $day $hour $minute $second");

    utilite = Utilite.fromJson(d.source!);

    year = utilite!.date.year;
    month = utilite!.date.month;
    day = utilite!.date.day;
    hour = utilite!.date.hour;
    minute = utilite!.date.minute;
    second = utilite!.date.second;
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
                ])).marginOnly(
          top: AppSizes.md,
        );
      },
    );
  }
}
