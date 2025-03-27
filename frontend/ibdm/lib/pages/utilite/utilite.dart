import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
import 'package:ibdm/common/widgets/radial_meter.dart';
import 'package:ibdm/common/widgets/temp_gauge.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
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

  late Co2Ifruit co2_ifruit;
  late Utilite utilite;

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
              printMessage("error: $e");
              UtilitePage.channel?.sink.close();
              UtilitePage.stream = null;
              load();
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> load() async {
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
              .getFiltrationMetaData();
          printMessage("utilite broadcast connected");
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
            Future.delayed(Duration(seconds: 1), load);
          } else {
            retries = 3;
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
                    return Center(
                      child: CircularProgressIndicator(),
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
                    co2_ifruit = Co2Ifruit.fromJson(data["data"]["co2_ifruit"]);
                    utilite = Utilite.fromJson(data["data"]["utilite"]);

                    Future.delayed(Duration(microseconds: 100),
                        () => utiliteEndDate.value = utilite.date);
                    year = utilite.date.year;
                    month = utilite.date.month;
                    day = utilite.date.day;
                    hour = utilite.date.hour;
                    minute = utilite.date.minute;
                    second = utilite.date.second;
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
                                  value1: utilite.utKrTt ?? 0,
                                  value2: utilite.utSidTt ?? 0,
                                  start: 0,
                                  end: 10,
                                  dangerTempHigh: 5,
                                  steps: 1,
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                TempGauge(
                                  title: "Temperature Compresseur",
                                  value1: utilite.utKrTc ?? 0,
                                  value2: utilite.utSidTc ?? 0,
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
                                  value1: utilite.utKrP7 ?? 0,
                                  value2: utilite.utSidP7 ?? 0,
                                  max: 10,
                                  danger: 6.5,
                                  title: "Pression 7",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite.utKrP40 ?? 0,
                                  value2: utilite.utSidP40 ?? 0,
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
                                  value1: utilite.utKrPn2 ?? 0,
                                  value2: utilite.utSidPn2 ?? 0,
                                  max: 10,
                                  danger: 6.5,
                                  title: "Pression Azote",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite.utKrPv ?? 0,
                                  value2: utilite.utSidPv ?? 0,
                                  max: 10,
                                  danger: 6.5,
                                  title: "Pression Chaudiere",
                                  value1Suffix: "Bars",
                                  value2Suffix: "Bars",
                                  value1Label: "Zone Krones",
                                  value2Label: "Zone Sidel",
                                ).marginAll(AppSizes.lg),
                                RadialMeter(
                                  value1: utilite.utKrPg ?? 0,
                                  value2: utilite.utSidPg ?? 0,
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
        done++;
        if (done == 2) {
          refresh.value = true;
          _state.value = FutureState.success;
          loaded.value = true;
          Future.delayed(Durations.long2, () {
            toastification.dismissById(toast.id);
          });
        }
      }

      api
          .getCo2IfruitAtSpecificTime(
            year: year!,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
          )
          .then((v) => {co2_ifruit = v, _setDone()});
      api
          .getUtiliteAtSpecificTime(
            year: year!,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
          )
          .then((v) => {utilite = v, _setDone()});
    } catch (e) {
      logger.e("Failed to get Utilite data");
      _state.value = FutureState.error;
      loaded.value = true;
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
      return null;
    }
  }

  _getTopActionsBar() {
    return Obx(() {
      return LiveDataTopActionBar(
        isLive: isLive,
        startDate: utiliteStartDate.value,
        endDate: utiliteEndDate.value,
        selectedDate: utiliteEndDate.value,
        searchPressed: (dt) {
          year = dt.year;
          month = dt.month;
          day = dt.day;
          hour = dt.hour;
          minute = dt.minute;
          second = dt.second;
          _getUtiliteData();
        },
      );
    });
  }
}
