import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';

import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SiroperiePage extends StatefulWidget {
  const SiroperiePage({super.key});

  @override
  State<SiroperiePage> createState() => _SiroperiePageState();
}

class _SiroperiePageState extends State<SiroperiePage> {
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

  static WebSocketChannel? _channel;
  Rx<bool> isLive = true.obs;
  static Stream? _stream;

  double convertSugarLToKG(double inL) {
    return inL * 1.33;
  }

  int retries = 3;

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCustomContainer(
      child: Obx(
        () {
          if (!loaded.value) {
            _load();
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot == null ||
                    snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null ||
                    snapshot.data == "" ||
                    JsonCodec().decode(snapshot.data) == null ||
                    JsonCodec().decode(snapshot.data)["data"] == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final sucre =
                    Sucre.fromJson(JsonCodec().decode(snapshot.data)["data"]);

                T02_value = sucre.aT02 != null ? sucre.aT02! * 100 / 140000 : 0;
                T03_value = sucre.aT03 != null ? sucre.aT03! * 100 / 140000 : 0;
                T04_value = sucre.aT04 != null ? sucre.aT04! * 100 / 140000 : 0;
                T05_value = sucre.aT05 != null ? sucre.aT05! * 100 / 60000 : 0;
                T06_value = sucre.aT06 != null ? sucre.aT06! * 100 / 60000 : 0;
                TS21_value = sucre.tS21 != null ? sucre.tS21! * 100 / 60000 : 0;
                TS22_value = sucre.tS22 != null ? sucre.tS22! * 100 / 60000 : 0;
                TS23_value = sucre.tS23 != null ? sucre.tS23! * 100 / 60000 : 0;
                TS24_value = sucre.tS24 != null ? sucre.tS24! * 100 / 60000 : 0;
                TS25_value = sucre.tS25 != null ? sucre.tS25! * 100 / 60000 : 0;

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
                              style: Theme.of(context).textTheme.titleLarge),
                        ).marginAll(AppSizes.md),
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

                        // main view
                        Expanded(
                          child: Container(
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
                                      Text(strings.value.sucreTetraTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )).marginAll(AppSizes.sm),
                                      Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          Cuve(
                                            title: "TS21",
                                            value: TS21_value,
                                            niveauInL: sucre.tS21 ?? 0,
                                            niveauInKG: convertSugarLToKG(
                                                sucre.tS21 ?? 0),
                                          ),
                                          Cuve(
                                            title: "TS22",
                                            value: TS22_value,
                                            niveauInL: sucre.tS22 ?? 0,
                                            niveauInKG: convertSugarLToKG(
                                                sucre.tS22 ?? 0),
                                          ),
                                          Cuve(
                                            title: "TS23",
                                            value: TS23_value,
                                            niveauInL: sucre.tS23 ?? 0,
                                            niveauInKG: convertSugarLToKG(
                                                sucre.tS23 ?? 0),
                                          ),
                                          Cuve(
                                            title: "TS24",
                                            value: TS24_value,
                                            niveauInL: sucre.tS24 ?? 0,
                                            niveauInKG: convertSugarLToKG(
                                                sucre.tS24 ?? 0),
                                          ),
                                          Cuve(
                                            title: "TS25",
                                            value: TS25_value,
                                            niveauInL: sucre.tS25 ?? 0,
                                            niveauInKG: convertSugarLToKG(
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
                                        Text(strings.value.sucreAdueTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                )).marginAll(AppSizes.sm),
                                        Wrap(
                                          alignment: WrapAlignment.spaceEvenly,
                                          children: [
                                            Cuve(
                                              title: "T02",
                                              value: T02_value,
                                              niveauInL: sucre.aT02 ?? 0,
                                              niveauInKG: convertSugarLToKG(
                                                  sucre.aT02 ?? 0),
                                            ),
                                            Cuve(
                                              title: "T03",
                                              value: T03_value,
                                              niveauInL: sucre.aT03 ?? 0,
                                              niveauInKG: convertSugarLToKG(
                                                  sucre.aT03 ?? 0),
                                            ),
                                            Cuve(
                                              title: "T04",
                                              value: T04_value,
                                              niveauInL: sucre.aT04 ?? 0,
                                              niveauInKG: convertSugarLToKG(
                                                  sucre.aT04 ?? 0),
                                            ),
                                            Cuve(
                                              title: "T05",
                                              value: T05_value,
                                              niveauInL: sucre.aT05 ?? 0,
                                              niveauInKG: convertSugarLToKG(
                                                  sucre.aT05 ?? 0),
                                            ),
                                            Cuve(
                                              title: "T06",
                                              value: T06_value,
                                              niveauInL: sucre.aT06 ?? 0,
                                              niveauInKG: convertSugarLToKG(
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
                          ),
                        ),
                        Container(
                          width: context.width,
                          decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )),
                          child: _getBottomDataBar(),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

_load() async {
    loaded.value = false;
    if (_stream == null) {
      try {
        _channel = WebSocketChannel.connect(
            Uri.parse(ApiConfig.sucre_broadcast_websocket_url));
        await _channel!.ready;
        _stream = _channel!.stream.asBroadcastStream();
        loaded.value = true;
      } catch (e) {
        logger.e(
            "Error connecting to sucre broadcast${retries > 0 ? ',retrying' : ''}");
        if (retries > 0) {
          retries--;
          Future.delayed(Duration(seconds: 1), _load);
        } else {
          retries = 3;
        }
        Toasts.showErrorToastNotification(
            context: Get.context!,
            message:
                "Failed To Connect To Sucre Broadcast${retries > 0 ? ',retrying' : ''}");
      }
    }
    loaded.value = true;
  }
  
  _getTopActionsBar() {
    final strings = getTranslations(context).obs;
    return Obx(
      () => Padding(
        padding: EdgeInsets.all(AppSizes.sm),
        child: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // show live data
            ShadButton(
              enabled: !isLive.value,
              backgroundColor: isLive.value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerLow,
              hoverBackgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: isLive.value
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              child: Text(isLive.value
                  ? strings.value.showingLiveData
                  : strings.value.showLiveData),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                // year
                ShadSelect(
                  decoration: ShadDecoration(
                      border: ShadBorder.none,
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      labelStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                  options: [
                    ShadOption(value: "2021", child: Text("2021")),
                    ShadOption(value: "2022", child: Text("2022")),
                    ShadOption(value: "2023", child: Text("2023")),
                    ShadOption(value: "2024", child: Text("2024")),
                    ShadOption(value: "2025", child: Text("2025")),
                  ],
                  onChanged: (value) {
                    print(value);
                  },
                  selectedOptionBuilder: (context, option) {
                    return Text(
                      strings.value.year(int.parse(option)),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    );
                  },
                  initialValue: "2025",
                ),
                // month
                ShadSelect(
                  options: [
                    ShadOption(
                        value: strings.value.january,
                        child: Text(strings.value.january)),
                    ShadOption(
                        value: strings.value.february,
                        child: Text(strings.value.february)),
                    ShadOption(
                        value: strings.value.march,
                        child: Text(strings.value.march)),
                    ShadOption(
                        value: strings.value.april,
                        child: Text(strings.value.april)),
                    ShadOption(
                        value: strings.value.may,
                        child: Text(strings.value.may)),
                    ShadOption(
                        value: strings.value.june,
                        child: Text(strings.value.june)),
                    ShadOption(
                        value: strings.value.july,
                        child: Text(strings.value.july)),
                    ShadOption(
                        value: strings.value.august,
                        child: Text(strings.value.august)),
                    ShadOption(
                        value: strings.value.september,
                        child: Text(strings.value.september)),
                    ShadOption(
                        value: strings.value.october,
                        child: Text(strings.value.october)),
                    ShadOption(
                        value: strings.value.november,
                        child: Text(strings.value.november)),
                    ShadOption(
                        value: strings.value.december,
                        child: Text(strings.value.december)),
                  ],
                  onChanged: (value) {
                    print(value);
                  },
                  selectedOptionBuilder: (context, option) {
                    return Text(strings.value.month(option));
                  },
                  initialValue: "December",
                ),
                // day
                ShadSelect(
                  options: [
                    ShadOption(value: "1", child: Text("1")),
                    ShadOption(value: "2", child: Text("2")),
                    ShadOption(value: "3", child: Text("3")),
                    ShadOption(value: "4", child: Text("4")),
                    ShadOption(value: "5", child: Text("5")),
                    ShadOption(value: "6", child: Text("6")),
                    ShadOption(value: "7", child: Text("7")),
                    ShadOption(value: "8", child: Text("8")),
                    ShadOption(value: "9", child: Text("9")),
                    ShadOption(value: "10", child: Text("10")),
                    ShadOption(value: "11", child: Text("11")),
                    ShadOption(value: "12", child: Text("12")),
                    ShadOption(value: "13", child: Text("13")),
                    ShadOption(value: "14", child: Text("14")),
                    ShadOption(value: "15", child: Text("15")),
                    ShadOption(value: "16", child: Text("16")),
                    ShadOption(value: "17", child: Text("17")),
                    ShadOption(value: "18", child: Text("18")),
                    ShadOption(value: "19", child: Text("19")),
                    ShadOption(value: "20", child: Text("20")),
                    ShadOption(value: "21", child: Text("21")),
                    ShadOption(value: "22", child: Text("22")),
                    ShadOption(value: "23", child: Text("23")),
                    ShadOption(value: "24", child: Text("24")),
                    ShadOption(value: "25", child: Text("25")),
                    ShadOption(value: "26", child: Text("26")),
                    ShadOption(value: "27", child: Text("27")),
                    ShadOption(value: "28", child: Text("28")),
                    ShadOption(value: "29", child: Text("29")),
                    ShadOption(value: "30", child: Text("30")),
                    ShadOption(value: "31", child: Text("31")),
                  ],
                  onChanged: (value) {
                    print(value);
                  },
                  selectedOptionBuilder: (context, option) {
                    return Text(strings.value.day(option));
                  },
                  initialValue: "7",
                ),
                // hour
                ShadSelect(
                  options: [
                    ShadOption(value: "0", child: Text("0")),
                    ShadOption(value: "1", child: Text("1")),
                    ShadOption(value: "2", child: Text("2")),
                    ShadOption(value: "3", child: Text("3")),
                    ShadOption(value: "4", child: Text("4")),
                    ShadOption(value: "5", child: Text("5")),
                    ShadOption(value: "6", child: Text("6")),
                    ShadOption(value: "7", child: Text("7")),
                    ShadOption(value: "8", child: Text("8")),
                    ShadOption(value: "9", child: Text("9")),
                    ShadOption(value: "10", child: Text("10")),
                    ShadOption(value: "11", child: Text("11")),
                    ShadOption(value: "12", child: Text("12")),
                    ShadOption(value: "13", child: Text("13")),
                    ShadOption(value: "14", child: Text("14")),
                    ShadOption(value: "15", child: Text("15")),
                    ShadOption(value: "16", child: Text("16")),
                    ShadOption(value: "17", child: Text("17")),
                    ShadOption(value: "18", child: Text("18")),
                    ShadOption(value: "19", child: Text("19")),
                    ShadOption(value: "20", child: Text("20")),
                    ShadOption(value: "21", child: Text("21")),
                    ShadOption(value: "22", child: Text("22")),
                    ShadOption(value: "23", child: Text("23")),
                  ],
                  onChanged: (value) {
                    print(value);
                  },
                  selectedOptionBuilder: (context, option) {
                    return Text(strings.value.hour(option));
                  },
                  initialValue: "12",
                ),
                // minute
                ShadSelect(
                  options: [
                    ShadOption(value: "0", child: Text("0")),
                    ShadOption(value: "1", child: Text("1")),
                    ShadOption(value: "2", child: Text("2")),
                    ShadOption(value: "3", child: Text("3")),
                    ShadOption(value: "4", child: Text("4")),
                    ShadOption(value: "5", child: Text("5")),
                    ShadOption(value: "6", child: Text("6")),
                    ShadOption(value: "7", child: Text("7")),
                    ShadOption(value: "8", child: Text("8")),
                    ShadOption(value: "9", child: Text("9")),
                    ShadOption(value: "10", child: Text("10")),
                    ShadOption(value: "11", child: Text("11")),
                    ShadOption(value: "12", child: Text("12")),
                    ShadOption(value: "13", child: Text("13")),
                    ShadOption(value: "14", child: Text("14")),
                    ShadOption(value: "15", child: Text("15")),
                    ShadOption(value: "16", child: Text("16")),
                    ShadOption(value: "17", child: Text("17")),
                    ShadOption(value: "18", child: Text("18")),
                    ShadOption(value: "19", child: Text("19")),
                    ShadOption(value: "20", child: Text("20")),
                    ShadOption(value: "21", child: Text("21")),
                    ShadOption(value: "22", child: Text("22")),
                    ShadOption(value: "23", child: Text("23")),
                    ShadOption(value: "24", child: Text("24")),
                    ShadOption(value: "25", child: Text("25")),
                    ShadOption(value: "26", child: Text("26")),
                    ShadOption(value: "27", child: Text("27")),
                    ShadOption(value: "28", child: Text("28")),
                    ShadOption(value: "29", child: Text("29")),
                    ShadOption(value: "30", child: Text("30")),
                    ShadOption(value: "31", child: Text("31")),
                    ShadOption(value: "32", child: Text("32")),
                    ShadOption(value: "33", child: Text("33")),
                    ShadOption(value: "34", child: Text("34")),
                    ShadOption(value: "35", child: Text("35")),
                    ShadOption(value: "36", child: Text("36")),
                    ShadOption(value: "37", child: Text("37")),
                    ShadOption(value: "38", child: Text("38")),
                    ShadOption(value: "39", child: Text("39")),
                    ShadOption(value: "40", child: Text("40")),
                    ShadOption(value: "41", child: Text("41")),
                    ShadOption(value: "42", child: Text("42")),
                    ShadOption(value: "43", child: Text("43")),
                    ShadOption(value: "44", child: Text("44")),
                    ShadOption(value: "45", child: Text("45")),
                    ShadOption(value: "46", child: Text("46")),
                    ShadOption(value: "47", child: Text("47")),
                    ShadOption(value: "48", child: Text("48")),
                    ShadOption(value: "49", child: Text("49")),
                    ShadOption(value: "50", child: Text("50")),
                    ShadOption(value: "51", child: Text("51")),
                    ShadOption(value: "52", child: Text("52")),
                    ShadOption(value: "53", child: Text("53")),
                    ShadOption(value: "54", child: Text("54")),
                    ShadOption(value: "55", child: Text("55")),
                    ShadOption(value: "56", child: Text("56")),
                    ShadOption(value: "57", child: Text("57")),
                    ShadOption(value: "58", child: Text("58")),
                    ShadOption(value: "59", child: Text("59")),
                  ],
                  onChanged: (value) {
                    print(value);
                  },
                  selectedOptionBuilder: (context, option) {
                    return Text(strings.value.minute(option));
                  },
                  initialValue: "30",
                ),
                // second
                ShadSelect(
                  options: [
                    ShadOption(value: "0", child: Text("0")),
                    ShadOption(value: "1", child: Text("1")),
                    ShadOption(value: "2", child: Text("2")),
                    ShadOption(value: "3", child: Text("3")),
                    ShadOption(value: "4", child: Text("4")),
                    ShadOption(value: "5", child: Text("5")),
                    ShadOption(value: "6", child: Text("6")),
                    ShadOption(value: "7", child: Text("7")),
                    ShadOption(value: "8", child: Text("8")),
                    ShadOption(value: "9", child: Text("9")),
                    ShadOption(value: "10", child: Text("10")),
                    ShadOption(value: "11", child: Text("11")),
                    ShadOption(value: "12", child: Text("12")),
                    ShadOption(value: "13", child: Text("13")),
                    ShadOption(value: "14", child: Text("14")),
                    ShadOption(value: "15", child: Text("15")),
                    ShadOption(value: "16", child: Text("16")),
                    ShadOption(value: "17", child: Text("17")),
                    ShadOption(value: "18", child: Text("18")),
                    ShadOption(value: "19", child: Text("19")),
                    ShadOption(value: "20", child: Text("20")),
                    ShadOption(value: "21", child: Text("21")),
                    ShadOption(value: "22", child: Text("22")),
                    ShadOption(value: "23", child: Text("23")),
                    ShadOption(value: "24", child: Text("24")),
                    ShadOption(value: "25", child: Text("25")),
                    ShadOption(value: "26", child: Text("26")),
                    ShadOption(value: "27", child: Text("27")),
                    ShadOption(value: "28", child: Text("28")),
                    ShadOption(value: "29", child: Text("29")),
                    ShadOption(value: "30", child: Text("30")),
                    ShadOption(value: "31", child: Text("31")),
                    ShadOption(value: "32", child: Text("32")),
                    ShadOption(value: "33", child: Text("33")),
                    ShadOption(value: "34", child: Text("34")),
                    ShadOption(value: "35", child: Text("35")),
                    ShadOption(value: "36", child: Text("36")),
                    ShadOption(value: "37", child: Text("37")),
                    ShadOption(value: "38", child: Text("38")),
                    ShadOption(value: "39", child: Text("39")),
                    ShadOption(value: "40", child: Text("40")),
                    ShadOption(value: "41", child: Text("41")),
                    ShadOption(value: "42", child: Text("42")),
                    ShadOption(value: "43", child: Text("43")),
                    ShadOption(value: "44", child: Text("44")),
                    ShadOption(value: "45", child: Text("45")),
                    ShadOption(value: "46", child: Text("46")),
                    ShadOption(value: "47", child: Text("47")),
                    ShadOption(value: "48", child: Text("48")),
                    ShadOption(value: "49", child: Text("49")),
                    ShadOption(value: "50", child: Text("50")),
                    ShadOption(value: "51", child: Text("51")),
                    ShadOption(value: "52", child: Text("52")),
                    ShadOption(value: "53", child: Text("53")),
                    ShadOption(value: "54", child: Text("54")),
                    ShadOption(value: "55", child: Text("55")),
                    ShadOption(value: "56", child: Text("56")),
                    ShadOption(value: "57", child: Text("57")),
                    ShadOption(value: "58", child: Text("58")),
                    ShadOption(value: "59", child: Text("59")),
                  ],
                  onChanged: (value) {
                    print(value);
                  },
                  selectedOptionBuilder: (context, option) {
                    return Text(strings.value.second(option));
                  },
                  initialValue: "0",
                ),
              ],
            ),

            // inventory button
            ShadButton(
              onPressed: () => _openInventoryDialog(),
              child: Text(strings.value.inventory),
            )
          ],
        ),
      ),
    );
  }

  _getBottomDataBar() {
    final strings = getTranslations(context).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSizes.sm),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  Text(
                    strings.value.totalSucre,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  Wrap(
                    children: [
                      SizedBox(width: AppSizes.lg)
                          .removeWhen(isAtLeastMediumScreen(context)),
                      Text(
                        " ${(sommeTetraL + sommeAdueL).toStringAsFixed(2)} L",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: (sommeTetraL + sommeAdueL) < 84000
                                  ? errorColor
                                  : successColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(width: AppSizes.lg),
                      Text(
                        " ${(sommeTetraKG + sommeAdueKG).toStringAsFixed(2)} KG",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  _getBottomDataBarTetra() {
    final strings = getTranslations(context).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(strings.value.totalSucreTetra,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              Text(
                " ${sommeTetraL.toStringAsFixed(2)} L",
                softWrap: false,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: sommeTetraL < 30000 ? errorColor : successColor,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(
                ",",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                " ${sommeTetraKG.toStringAsFixed(2)} KG",
                softWrap: false,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          sommeTetraKG < 30000 * 3 ? errorColor : successColor,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ));
  }

  _getBottomDataBarAdue() {
    final strings = getTranslations(context).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(strings.value.totalSucreAdue,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              Text(
                " ${sommeAdueL.toStringAsFixed(2)} L",
                softWrap: false,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: sommeAdueL < 54000 ? errorColor : successColor,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(
                ",",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                " ${sommeAdueKG.toStringAsFixed(2)} KG",
                softWrap: false,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          sommeAdueKG < 54000 * 3 ? errorColor : successColor,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ));
  }

  _openInventoryDialog() async {
    final strings = getTranslations(context).obs;
    Sucre? sucre;

    final Rx<DateTime> _selectedDate = DateTime.now().obs;
    final Rx<bool> _dataLoaded = false.obs;
    final Rx<bool> _failed = false.obs;

    _getSucreData() async {
      _dataLoaded.value = false;
      try {
        sucre =
            await (await ApiClientInstance.getApiClient()).getAtSpecificTime(
          year: _selectedDate.value.year,
          month: _selectedDate.value.month,
          day: _selectedDate.value.day,
        );
        _failed.value = false;
        _dataLoaded.value = true;
      } catch (e) {
        _failed.value = true;
        _dataLoaded.value = true;
        Toasts.showErrorToast(
          context: context,
          message: strings.value.failedToGetInventory,
        );
      }
    }

    return showShadDialog(
      context: context,
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
              allowDeselection: false,
              formatDate: (date) => "${date.day}/${date.month}/${date.year}",
              selected: _selectedDate.value,
            ),
            SizedBox(height: AppSizes.lg),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.width,
                  minHeight: 550,
                  maxHeight: 550,
                ),
                child: Obx(() {
                  if (!_dataLoaded.value) {
                    _getSucreData();
                    return Center(
                      child: CircularProgressIndicator(),
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
                  return ShadTable.list(
                    columnSpanExtent: (t) => FixedTableSpanExtent(125),
                    header: [
                      ShadTableCell.header(child: Text("Cuve")),
                      ShadTableCell.header(child: Text("Niveau en L")),
                      ShadTableCell.header(child: Text("Niveau en KG")),
                      ShadTableCell.header(child: Text("Fill")),
                    ],
                    children: [
                      for (var r in [
                        InventoryRow(
                          nom: "TS21",
                          niveauL: "${sucre!.tS21?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.tS21 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_TS21_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "TS22",
                          niveauL: "${sucre!.tS22?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.tS22 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_TS22_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "TS23",
                          niveauL: "${sucre!.tS23?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.tS23 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_TS23_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "TS24",
                          niveauL: "${sucre!.tS24?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.tS24 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_TS24_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "TS25",
                          niveauL: "${sucre!.tS25?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.tS25 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_TS25_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "T02",
                          niveauL: "${sucre!.aT02?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.aT02 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_T02_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "T03",
                          niveauL: "${sucre!.aT03?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.aT03 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_T03_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "T04",
                          niveauL: "${sucre!.aT04?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.aT04 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_T04_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "T05",
                          niveauL: "${sucre!.aT05?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.aT05 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_T05_value.toStringAsFixed(2)}%",
                        ),
                        InventoryRow(
                          nom: "T06",
                          niveauL: "${sucre!.aT06?.toStringAsFixed(2) ?? 0} L",
                          niveauKG:
                              "${convertSugarLToKG(sucre!.aT06 ?? 0).toStringAsFixed(2)} KG",
                          fill: "${_T06_value.toStringAsFixed(2)}%",
                        ),
                      ])
                        [
                          ShadTableCell(
                            child: Text(r.nom),
                          ),
                          ShadTableCell(
                            child: Text(r.niveauL),
                          ),
                          ShadTableCell(
                            child: Text(r.niveauKG),
                          ),
                          ShadTableCell(
                            child: Text(r.fill),
                          ),
                        ],
                    ],
                  );
                }),
              ),
            )
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
  InventoryRow({
    required this.nom,
    required this.niveauL,
    required this.niveauKG,
    required this.fill,
  });
}

class Cuve extends StatelessWidget {
  const Cuve({
    super.key,
    this.title = "Title",
    this.value = 0,
    this.niveauInKG = 0,
    this.niveauInL = 0,
    this.okColor = AppColors.successColor,
    this.dangerColor = AppColors.errorColor,
    this.dangerPoint = 10,
  });

  final String title;
  final double value;
  final double niveauInL;
  final double niveauInKG;
  final Color okColor;
  final Color dangerColor;
  final double dangerPoint;
  Color get color => value > dangerPoint ? okColor : dangerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: LinearGauge(
              start: 0,
              end: 100,
              fillExtend: true,
              enableGaugeAnimation: true,
              gaugeOrientation: GaugeOrientation.vertical,
              pointers: [
                WidgetPointer(
                  value: 50,
                  pointerPosition: PointerPosition.center,
                  pointerAlignment: PointerAlignment.center,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 90),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: color,
                          ),
                        ).marginAll(AppSizes.sm),
                        FittedBox(
                          child: Text(
                            "${niveauInL.toStringAsFixed(2)} L",
                            softWrap: false,
                            style: TextStyle(
                              color: color,
                            ),
                          ).marginAll(AppSizes.sm),
                        ),
                        FittedBox(
                          child: Text(
                            "${niveauInKG.toStringAsFixed(2)} KG",
                            softWrap: false,
                            style: TextStyle(
                              color: color,
                            ),
                          ).marginAll(AppSizes.sm),
                        ),
                      ],
                    ),
                  ).marginAll(AppSizes.sm),
                ),
                WidgetPointer(
                    value: value,
                    isInteractive: true,
                    pointerPosition: PointerPosition.left,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${value.toStringAsFixed(2)}%",
                          style: TextStyle(color: color),
                        ),
                        Icon(Icons.arrow_right, color: color),
                      ],
                    ))
              ],
              customLabels: [
                CustomRulerLabel(text: "0%", value: 0),
                CustomRulerLabel(text: "20%", value: 20),
                CustomRulerLabel(text: "40%", value: 40),
                CustomRulerLabel(text: "50%", value: 50),
                CustomRulerLabel(text: "60%", value: 60),
                CustomRulerLabel(text: "80%", value: 80),
                CustomRulerLabel(text: "100%", value: 100),
              ],
              extendLinearGauge: 5,
              animationDuration: 2000,
              rangeLinearGauge: [
                RangeLinearGauge(
                  start: 0,
                  end: value,
                  color: color,
                )
              ],
              linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
                backgroundColor: AppColors.grey,
                borderRadius: 10,
                thickness: 100,
                linearGaugeValueColor: AppColors.accentColor,
              ),
              rulers: RulerStyle(
                  inverseRulers: false,
                  showPrimaryRulers: true,
                  showSecondaryRulers: true,
                  rulerPosition: RulerPosition.right),
            ),
          ),
          Text(title, style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    );
  }
}
