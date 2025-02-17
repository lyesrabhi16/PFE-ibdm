import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class SiroperiePage extends StatefulWidget {
  const SiroperiePage({super.key});

  @override
  State<SiroperiePage> createState() => _SiroperiePageState();
}





class _SiroperiePageState extends State<SiroperiePage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://server.ibdm.local.ifri/ws/sucre'),
  )

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

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: AppCustomContainer(
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
                  child: Column(
                    children: [
                      // sucre tetra
                      Expanded(
                        child: Column(
                          children: [
                            Text(strings.value.sucreTetraTitle,
                                    style:
                                        Theme.of(context).textTheme.titleMedium)
                                .marginAll(AppSizes.sm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Cuve(
                                  title: "TS21",
                                  value: TS21_value,
                                  niveaInL: 60000 * TS21_value / 100,
                                  niveaInKG: 60000 * TS21_value / 100 * 3,
                                ),
                                Cuve(
                                  title: "TS22",
                                  value: TS22_value,
                                  niveaInL: 60000 * TS22_value / 100,
                                  niveaInKG: 60000 * TS22_value / 100 * 3,
                                ),
                                Cuve(
                                  title: "TS23",
                                  value: TS23_value,
                                  niveaInL: 60000 * TS23_value / 100,
                                  niveaInKG: 60000 * TS24_value / 100 * 3,
                                ),
                                Cuve(
                                  title: "TS24",
                                  value: TS24_value,
                                  niveaInL: 60000 * TS24_value / 100,
                                  niveaInKG: 60000 * TS24_value / 100 * 3,
                                ),
                                Cuve(
                                  title: "TS25",
                                  value: TS25_value,
                                  niveaInL: 60000 * TS25_value / 100,
                                  niveaInKG: 60000 * TS25_value / 100 * 3,
                                ),
                              ],
                            ),
                            _getBottomDataBarTetra(),
                          ],
                        ),
                      ),

                      // sucre adue
                      Expanded(
                        child: Container(
                          color: colorScheme.secondaryContainer,
                          child: Column(
                            children: [
                              Text(strings.value.sucreAdueTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium)
                                  .marginAll(AppSizes.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Cuve(
                                    title: "T02",
                                    value: T02_value,
                                    niveaInL: 140000 * T02_value / 100,
                                    niveaInKG: 140000 * T02_value / 100 * 3,
                                  ),
                                  Cuve(
                                    title: "T03",
                                    value: T03_value,
                                    niveaInL: 140000 * T03_value / 100,
                                    niveaInKG: 140000 * T03_value / 100 * 3,
                                  ),
                                  Cuve(
                                    title: "T04",
                                    value: T04_value,
                                    niveaInL: 140000 * T04_value / 100,
                                    niveaInKG: 140000 * T04_value / 100 * 3,
                                  ),
                                  Cuve(
                                    title: "T05",
                                    value: T05_value,
                                    niveaInL: 60000 * T05_value / 100,
                                    niveaInKG: 60000 * T05_value / 100 * 3,
                                  ),
                                  Cuve(
                                    title: "T06",
                                    value: T06_value,
                                    niveaInL: 60000 * T06_value / 100,
                                    niveaInKG: 60000 * T06_value / 100 * 3,
                                  ),
                                ],
                              ),
                              _getBottomDataBarAdue(),
                            ],
                          ),
                        ),
                      ),
                    ],
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
      ),
    );
  }

  _getTopActionsBar() {
    final strings = getTranslations(context).obs;
    return Obx(
      () => Padding(
        padding: EdgeInsets.all(AppSizes.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShadButton(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerLow,
              hoverBackgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              child: Text(strings.value.showLiveData),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }

  _getBottomDataBar() {
    final strings = getTranslations(context).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                      text: strings.value.totalSucre,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                    TextSpan(text: " "),
                    TextSpan(
                        text: "50000 L",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: successColor,
                                  fontStyle: FontStyle.italic,
                                )),
                    TextSpan(text: ","),
                    TextSpan(text: " "),
                    TextSpan(
                        text: "150000 KG",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: successColor,
                                  fontStyle: FontStyle.italic,
                                )),
                  ]))
            ],
          ),
        ));
  }

  _getBottomDataBarTetra() {
    final strings = getTranslations(context).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                      text: strings.value.totalSucreTetra,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                    TextSpan(text: " "),
                    TextSpan(
                        text: "25000 L",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: successColor,
                                  fontStyle: FontStyle.italic,
                                )),
                    TextSpan(text: ","),
                    TextSpan(text: " "),
                    TextSpan(
                        text: "75000 KG",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: successColor,
                                  fontStyle: FontStyle.italic,
                                )),
                  ]))
            ],
          ),
        ));
  }

  _getBottomDataBarAdue() {
    final strings = getTranslations(context).obs;
    return Obx(() => Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                      text: strings.value.totalSucreAdue,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                    TextSpan(text: " "),
                    TextSpan(
                        text: "50000 L",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: successColor,
                                  fontStyle: FontStyle.italic,
                                )),
                    TextSpan(text: ","),
                    TextSpan(text: " "),
                    TextSpan(
                        text: "150000 KG",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: successColor,
                                  fontStyle: FontStyle.italic,
                                )),
                  ]))
            ],
          ),
        ));
  }
}

class Cuve extends StatelessWidget {
  const Cuve({
    super.key,
    this.title = "Title",
    this.value = 5,
    this.niveaInL = 5000,
    this.niveaInKG = 15000,
    this.okColor = AppColors.successColor,
    this.dangerColor = AppColors.errorColor,
    this.dangerPoint = 20,
  });

  final String title;
  final double value;
  final double niveaInL;
  final double niveaInKG;
  final Color okColor;
  final Color dangerColor;
  final double dangerPoint;
  Color get color => value > dangerPoint ? okColor : dangerColor;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      Text(
                        "$niveaInL L",
                        style: TextStyle(
                          color: color,
                        ),
                      ).marginAll(AppSizes.sm),
                      Text(
                        "$niveaInKG KG",
                        style: TextStyle(
                          color: color,
                        ),
                      ).marginAll(AppSizes.sm),
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
                        "$value%",
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
                color: AppColors.successColor,
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
    );
  }
}
