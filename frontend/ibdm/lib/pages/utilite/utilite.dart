import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/live_data_top_action_bar.dart';
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
              message:
                  "Failed To Connect To utilite Broadcast${retries > 0 ? ', retrying' : ''}");
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

class TempGauge extends StatelessWidget {
  const TempGauge({
    super.key,
    this.start = 0,
    this.end = 10,
    this.value1 = 5,
    this.value2 = 5,
    this.title = "Title",
    this.value1Label = "VALUE1",
    this.value2Label = "VALUE2",
    this.steps = 1,
    this.dangerTempHigh = 8,
    this.value1Suffix = "°C",
    this.value2Suffix = "°C",
    this.okValue1Color,
    this.okValue2Color,
    this.dangerValue1Color,
    this.dangerValue2Color,
  });
  final double start;
  final double end;
  final double value1;
  final double value2;
  final double dangerTempHigh;
  final String title;
  final String value1Label;
  final String value2Label;
  final double steps;
  final String value1Suffix;
  final String value2Suffix;
  final Color? okValue1Color;
  final Color? okValue2Color;
  final Color? dangerValue1Color;
  final Color? dangerValue2Color;

  @override
  Widget build(BuildContext context) {
    final Color _okValue1Color = okValue1Color ?? Colors.blue;
    final Color _okValue2Color = okValue2Color ?? Colors.orange;
    final Color _dangerValue1Color = dangerValue1Color ?? errorColor;
    final Color _dangerValue2Color = dangerValue2Color ?? errorColor;
    final Color _value1Color =
        value1 >= dangerTempHigh ? _dangerValue1Color : _okValue1Color;
    final Color _value2Color =
        value2 >= dangerTempHigh ? _dangerValue2Color : _okValue2Color;
    final _value1 = value1 <= end ? value1 : end;
    final _value2 = value2 <= end ? value2 : end;

    return Column(children: [
      SizedBox(
        width: 300,
        height: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                width: 150,
                height: 250,
                child: LinearGauge(
                  enableGaugeAnimation: true,
                  start: start,
                  end: end,
                  fillExtend: true,
                  steps: steps,
                  extendLinearGauge: 5,
                  valueBar: [
                    ValueBar(
                      value: _value1,
                      color: _value1Color,
                      valueBarThickness: 25,
                    ),
                  ],
                  gaugeOrientation: GaugeOrientation.vertical,
                  linearGaugeBoxDecoration:
                      LinearGaugeBoxDecoration(borderRadius: 20, thickness: 25),
                  rulers: RulerStyle(
                    rulerPosition: RulerPosition.right,
                  ),
                  pointers: [
                    Pointer(
                      shape: PointerShape.circle,
                      color: _value1Color,
                      value: 0,
                      enableAnimation: false,
                      showLabel: false,
                      height: 30,
                      width: 100,
                      pointerAlignment: PointerAlignment.center,
                      pointerPosition: PointerPosition.center,
                    ),
                    WidgetPointer(
                        value: _value1,
                        isInteractive: false,
                        pointerPosition: PointerPosition.left,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${value1.toStringAsFixed(2)} $value1Suffix",
                              style: TextStyle(
                                  color: _value1Color,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_right, color: _value1Color),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 150,
                height: 250,
                child: LinearGauge(
                  enableGaugeAnimation: true,
                  start: start,
                  end: end,
                  fillExtend: true,
                  steps: steps,
                  extendLinearGauge: 5,
                  valueBar: [
                    ValueBar(
                      value: _value2,
                      color: _value2Color,
                      valueBarThickness: 25,
                    ),
                  ],
                  gaugeOrientation: GaugeOrientation.vertical,
                  linearGaugeBoxDecoration:
                      LinearGaugeBoxDecoration(borderRadius: 20, thickness: 25),
                  rulers: RulerStyle(
                    rulerPosition: RulerPosition.right,
                  ),
                  pointers: [
                    Pointer(
                      shape: PointerShape.circle,
                      color: _value2Color,
                      value: 0,
                      enableAnimation: false,
                      showLabel: false,
                      height: 30,
                      width: 100,
                      pointerAlignment: PointerAlignment.center,
                      pointerPosition: PointerPosition.center,
                    ),
                    WidgetPointer(
                        value: _value2,
                        isInteractive: false,
                        pointerPosition: PointerPosition.left,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${value2.toStringAsFixed(2)} $value2Suffix",
                              style: TextStyle(
                                  color: _value2Color,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_right, color: _value2Color),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 300,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Wrap(
                children: [
                  Text(
                    value1Label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: _value1Color),
                  ).marginSymmetric(horizontal: AppSizes.sm),
                  Text(
                    "${value1.toStringAsFixed(2)} $value1Suffix",
                    textAlign: TextAlign.center,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: _value1Color),
                  ).marginSymmetric(horizontal: AppSizes.sm),
                ],
              ),
              Wrap(
                children: [
                  Text(
                    value2Label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: _value2Color),
                  ).marginSymmetric(horizontal: AppSizes.sm),
                  Text(
                    "${value2.toStringAsFixed(2)} $value2Suffix",
                    textAlign: TextAlign.center,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: _value2Color),
                  ).marginSymmetric(horizontal: AppSizes.sm),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class RadialMeter extends StatelessWidget {
  const RadialMeter({
    super.key,
    this.value1 = 7,
    this.value2 = 3,
    this.zeroOffset = 0.005,
    this.max = 10,
    this.danger = 6,
    this.title = "Title",
    this.value1Label = "VALUE1",
    this.value2Label = "VALUE2",
    this.steps = 1,
    this.value1Suffix = "",
    this.value2Suffix = "",
    this.okValue1Color,
    this.okValue2Color,
    this.dangerValue1Color,
    this.dangerValue2Color,
  });

  final double value1;
  final double value2;
  final double zeroOffset;
  final double max;
  final double danger;
  final String title;
  final String value1Label;
  final String value2Label;
  final int steps;
  final String value1Suffix;
  final String value2Suffix;
  final Color? okValue1Color;
  final Color? okValue2Color;
  final Color? dangerValue1Color;
  final Color? dangerValue2Color;
  @override
  Widget build(BuildContext context) {
    final Color _okValue1Color = okValue1Color ?? Colors.blue;
    final Color _okValue2Color = okValue2Color ?? Colors.orange;
    final Color _dangerValue1Color = dangerValue1Color ?? errorColor;
    final Color _dangerValue2Color = dangerValue2Color ?? errorColor;

    final Color _value1Color =
        value1 <= danger ? _dangerValue1Color : _okValue1Color;
    final Color _value2Color =
        value2 <= danger ? _dangerValue2Color : _okValue2Color;

    return SizedBox(
      width: 250,
      height: 250,
      child: Center(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      value1Label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: _value1Color),
                    ),
                    Text(
                      "${value1.toStringAsFixed(2)} $value1Suffix",
                      textAlign: TextAlign.center,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: _value1Color),
                    ),
                    Text(
                      value2Label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: _value2Color),
                    ),
                    Text(
                      "${value2.toStringAsFixed(2)} $value2Suffix",
                      textAlign: TextAlign.center,
                      softWrap: false,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: _value2Color),
                    ),
                  ],
                ),
              ),
            ),
            RadialGauge(
              track: RadialTrack(
                  start: 0,
                  end: max,
                  steps: steps,
                  hideTrack: true,
                  trackStyle: TrackStyle(
                    showPrimaryRulers: true,
                    showSecondaryRulers: true,
                    rulersOffset: 10,
                    labelOffset: 50,
                  )),
              radiusFactor: 1,
              valueBar: [
                RadialValueBar(
                  value: max,
                  color: Colors.grey.withAlpha(80),
                  radialOffset: 0,
                ),
                RadialValueBar(
                  value: value1 > 0
                      ? value1 > max
                          ? max
                          : value1
                      : zeroOffset,
                  color: _value1Color,
                  radialOffset: 0,
                ),
                RadialValueBar(
                  value: max,
                  color: Colors.grey.withAlpha(80),
                  radialOffset: 15,
                ),
                RadialValueBar(
                  value: value2 > 0
                      ? value2 > max
                          ? max
                          : value2
                      : zeroOffset,
                  color: _value2Color,
                  radialOffset: 15,
                ),
              ],
              widgetPointer: [],
            ),
          ],
        ),
      ),
    );
  }
}
