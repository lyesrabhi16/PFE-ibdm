import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/common_heplers.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class GraphType {
  final String name;
  final String ySuffix;
  final bool supportsFetchType;
  final Future<Map> Function(DateTime start, DateTime end, FetchType? fetchType)
      getGraphData;

  GraphType({
    required this.name,
    required this.getGraphData,
    this.ySuffix = " L",
    this.supportsFetchType = true,
  });
}

class AppLineChart extends StatelessWidget {
  final List<GraphType> graphTypes;

  AppLineChart({
    super.key,
    required this.graphTypes,
  });

  DateTime startDate = DateTime.now().copyWith(
    hour: 0,
    minute: 0,
    second: 0,
    millisecond: 0,
    microsecond: 0,
  );
  DateTime endDate = DateTime.now().copyWith(
    hour: 23,
    minute: 59,
    second: 59,
    millisecond: 999,
    microsecond: 999,
  );
  FetchType? fetchType;
  Rx<GraphType?> graphType = Rx<GraphType?>(null);

  double? minY;
  double? maxY;

  final RxBool graphLoaded = false.obs;
  final Map graphData = {};

  int skip = 0;
  get ySuffix => graphType.value!.ySuffix;
  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;
  String? lastReqId;
  @override
  Widget build(BuildContext context) {
    if (graphTypes.isEmpty) {
      return const SizedBox.shrink();
    }
    graphType.value = graphTypes.first;
    _getContext = () => context;
    final strings = getTranslations(context).obs;

    return Obx(() {
      fetchType = graphType.value!.supportsFetchType
          ? fetchType ?? FetchType.hours
          : null;
      if (graphData.isEmpty && !graphLoaded.value) {
        lastReqId = getUniqueId();
        _getGraphData(reqId: lastReqId!);
      }

      //logger.e("graph data: $graphData");

      return Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ShadSelect<GraphType>(
                  onChanged: (value) {
                    graphType.value = value!;
                    fetchType =
                        graphType.value!.supportsFetchType ? fetchType : null;
                  },
                  allowDeselection: false,
                  initialValue: graphType.value!,
                  options: [
                    for (var e in graphTypes)
                      ShadOption(
                        value: e,
                        child: Text(e.name.capitalize!),
                      ),
                  ],
                  selectedOptionBuilder: (context, value) {
                    return Text(
                      "${strings.value.type} : ${value.name.capitalize!}",
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    );
                  },
                ),
                if (graphType.value!.supportsFetchType)
                  ShadSelect<FetchType>(
                    enabled: graphType.value!.supportsFetchType,
                    placeholder: Text(strings.value.precision),
                    onChanged: (value) {
                      fetchType = value!;
                    },
                    allowDeselection: false,
                    initialValue: fetchType,
                    options: [
                      for (var e in FetchType.values
                          .where((e) => e != FetchType.$unknown))
                        ShadOption(
                          value: e,
                          child: Text(e.name.capitalize!),
                        ),
                    ],
                    selectedOptionBuilder: (context, value) {
                      return Text(
                        "${strings.value.precision} : ${value.name.capitalize!}",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(),
                      );
                    },
                  ),
                ShadDatePicker.range(
                  onRangeChanged: (value) {
                    startDate = value!.start!.copyWith(
                      hour: 0,
                      minute: 0,
                      second: 0,
                      millisecond: 0,
                      microsecond: 0,
                    );
                    endDate = value.end?.copyWith(
                          hour: 23,
                          minute: 59,
                          second: 59,
                          millisecond: 999,
                          microsecond: 999,
                        ) ??
                        value.start!.copyWith(
                          hour: 23,
                          minute: 59,
                          second: 59,
                          millisecond: 999,
                          microsecond: 999,
                        );
                    //print("getGraphData: $value");
                  },
                  closeOnSelection: false,
                  closeOnTapOutside: true,
                  formatDateRange: (dateRange) =>
                      dateTimeRangeToString(dateRange.start, dateRange.end),
                  selectableDayPredicate: (day) => true,
                  allowDeselection: false,
                  selected: ShadDateTimeRange(
                    start: startDate,
                    end: endDate,
                  ),
                ),
                ShadButton(
                  child: Text(strings.value.find),
                  onPressed: () {
                    lastReqId = getUniqueId();
                    _getGraphData(reqId: lastReqId!);
                  },
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            DividerWithText(
                text:
                    "${graphType.value!.name.toUpperCase()} ${dateTimeRangeToString(
              startDate,
              endDate,
              includeTime: graphType.value!.supportsFetchType
                  ? [
                      FetchType.days,
                      FetchType.weeks,
                      FetchType.months,
                      FetchType.years,
                    ].contains(fetchType)
                      ? false
                      : true
                  : false,
            )} "),
            SizedBox(height: AppSizes.sm),
            Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSizes.sm,
              children: [
                for (var key in graphData.keys)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: AppColors.getColorFromString(key,
                            backgroundColor: getBackgroundColor()),
                      ),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        key,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: AppSizes.sm),
            !graphLoaded.value
                ? SizedBox(
                    height: 600,
                    child: CircularProgressIndicatorWithText(
                      text: strings.value.loading,
                    ),
                  )
                : graphData.isEmpty
                    ? SizedBox(
                        height: 600,
                        child: Center(
                          child: Text(strings.value.dataNotFound),
                        ),
                      )
                    : Builder(builder: (context) {
                        double? first;
                        double? last;
                        first = null;
                        last = null;
                        minY = null;
                        maxY = null;
                        final spots = {};
                        for (var e in graphData.entries) {
                          spots[e.key] = <FlSpot>[];
                          if (e.value.isEmpty) {
                            continue;
                          }
                          first ??= e.value.first["x"].toDouble();
                          last ??= e.value.last["x"].toDouble();
                          minY ??= e.value.first["y"].toDouble();
                          maxY ??= e.value.last["y"].toDouble();

                          if (first! > e.value.first["x"].toDouble()) {
                            first = e.value.first["x"].toDouble();
                          }
                          if (last! < e.value.last["x"].toDouble()) {
                            last = e.value.last["x"].toDouble();
                          }

                          if (minY! > e.value.first["y"].toDouble()) {
                            minY = e.value.first["y"].toDouble();
                          }
                          if (maxY! < e.value.last["y"].toDouble()) {
                            maxY = e.value.last["y"].toDouble();
                          }

                          for (var d in e.value) {
                            spots[e.key].add(
                                FlSpot(d["x"].toDouble(), d["y"].toDouble()));
                          }
                        }
                        logger.e("spots: $spots");

                        final shownXTitles = <String>[];
                        final shownXValues = <double>[];
                        double width = context.width;
                        return SizedBox(
                          width: context.width,
                          height: context.height / 2,
                          child: LineChart(LineChartData(
                              gridData: FlGridData(
                                verticalInterval: getInterval(
                                    startDate: startDate,
                                    endDate: endDate,
                                    fetchType: fetchType,
                                    width: width),
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: AppColors.black.withAlpha(20),
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return FlLine(
                                    color: AppColors.black.withAlpha(20),
                                  );
                                },
                              ),
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  fitInsideHorizontally: true,
                                  fitInsideVertically: true,
                                  getTooltipColor: (value) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerLowest;
                                  },
                                  showOnTopOfTheChartBoxArea: true,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((touchedSpot) {
                                      final x =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              touchedSpot.x.toInt());
                                      final y = touchedSpot.y;
                                      final key = graphData.keys
                                          .elementAt(touchedSpot.barIndex);
                                      return LineTooltipItem(
                                        "$key : ${NumberFormat.compactCurrency(
                                          decimalDigits: 2,
                                          locale: "fr",
                                          symbol: ySuffix,
                                        ).format(y)}",
                                        Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  AppColors.getColorFromString(
                                                key,
                                                backgroundColor:
                                                    getBackgroundColor(),
                                              ),
                                            ),
                                        children: [
                                          TextSpan(
                                            text:
                                                "\n${x.day.toString().padLeft(2, "0")}/${x.month.toString().padLeft(2, "0")}/${x.year.toString().padLeft(2, "0")}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors
                                                      .getColorFromString(key,
                                                          backgroundColor:
                                                              getBackgroundColor()),
                                                ),
                                          ),
                                          TextSpan(
                                            text:
                                                "\n${x.hour.toString().padLeft(2, "0")}:${x.minute.toString().padLeft(2, "0")}:${x.second.toString().padLeft(2, "0")}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors
                                                      .getColorFromString(key,
                                                          backgroundColor:
                                                              getBackgroundColor()),
                                                ),
                                          )
                                        ],
                                      );
                                    }).toList();
                                  },
                                  tooltipRoundedRadius: 5,
                                  tooltipPadding: EdgeInsets.all(AppSizes.sm),
                                  tooltipMargin: AppSizes.sm,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  drawBelowEverything: true,
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    maxIncluded: false,
                                    minIncluded: false,
                                    //interval: getLeftInterval(),
                                    reservedSize: 100,
                                    getTitlesWidget: (value, meta) {
                                      return Text(NumberFormat.compactCurrency(
                                        decimalDigits: 2,
                                        locale: "fr",
                                        symbol: ySuffix,
                                      ).format(value));
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  drawBelowEverything: true,
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    minIncluded: false,
                                    maxIncluded: false,
                                    interval: getInterval(
                                      startDate: startDate,
                                      endDate: endDate,
                                      fetchType: fetchType,
                                      width: width,
                                    ),
                                    reservedSize: 100,
                                    getTitlesWidget: (value, meta) {
                                      width = meta.parentAxisSize;
                                      final date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              value.toInt());
                                      if (shownXValues.isNotEmpty) {
                                        final _date = switch (fetchType) {
                                          FetchType.hours => DateTime(date.year,
                                              date.month, date.day, date.hour),
                                          FetchType.days => DateTime(
                                              date.year, date.month, date.day),
                                          FetchType.weeks => DateTime(
                                              date.year, date.month, date.day),
                                          FetchType.months =>
                                            DateTime(date.year, date.month),
                                          FetchType.years =>
                                            DateTime(date.year),
                                          _ => DateTime(date.year, date.month,
                                              date.day, date.hour, date.minute),
                                        };
                                        final dateDiff = _date
                                            .difference(DateTime
                                                .fromMicrosecondsSinceEpoch(
                                                    shownXValues.last.toInt()))
                                            .inMilliseconds;

                                        if (dateDiff <=
                                            (getInterval(
                                              startDate: startDate,
                                              endDate: endDate,
                                              fetchType: fetchType,
                                              width: width,
                                            ))) {
                                          /* printMessage(
                                              "skip diff: $dateDiff interval: ${count * getInterval(startDate: startDate, endDate: endDate, fetchType: fetchType, width: width)}");
                                           */
                                          return const SizedBox.shrink();
                                        }
                                      }

                                      /* printMessage(
                                          "date: $date, value: $value, count: $count, shownXValues: $shownXValues");
 */
                                      String formattedDate =
                                          switch (fetchType) {
                                        FetchType.hours => DateFormat(
                                                endDate.day == startDate.day
                                                    ? "HH:mm"
                                                    : "dd/MM/yyyy HH:mm")
                                            .format(date),
                                        FetchType.days =>
                                          DateFormat("dd/MM/yyyy").format(date),
                                        FetchType.weeks => getWeek(date),
                                        FetchType.months => getMonth(date),
                                        FetchType.years => date.year.toString(),
                                        _ => DateFormat(
                                                endDate.day == startDate.day
                                                    ? "HH:mm"
                                                    : "dd/MM/yyyy HH:mm")
                                            .format(date),
                                      };
                                      if (!(shownXTitles.lastOrNull ==
                                          formattedDate)) {
                                        shownXTitles.add(formattedDate);
                                        shownXValues.add(value);
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                      return Container(
                                        child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                formattedDate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                textAlign: TextAlign.center,
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.black.withAlpha(100),
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: AppColors.black.withAlpha(100),
                                    width: 2,
                                  ),
                                  right: BorderSide.none,
                                  top: BorderSide.none,
                                ),
                              ),
                              lineBarsData: [
                                for (var e in graphData.entries)
                                  LineChartBarData(
                                    spots: spots[e.key] ?? [],
                                    isCurved: true,
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    color: AppColors.getColorFromString(e.key,
                                        backgroundColor: getBackgroundColor()),
                                    curveSmoothness: 0.5,
                                    preventCurveOverShooting: true,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.getColorFromString(e.key,
                                              backgroundColor:
                                                  getBackgroundColor())
                                          .withAlpha(50),
                                    ),
                                  ),
                              ])),
                        );
                      }),
          ],
        ),
      );
    });
  }

  Future<void> _getGraphData({
    required String reqId,
  }) async {
    graphLoaded.value = false;
    lastReqId = reqId;
    try {
      graphData.clear();
      /* print(
          "getGraphData: startDate: $startDate endDate: $endDate fetchType: $fetchType");
       */
      final res =
          await graphType.value!.getGraphData(startDate, endDate, fetchType);
      if (reqId == lastReqId) {
        graphData.addEntries(res.entries);
      }
      //logger.e("graph data: $graphData");
    } catch (e) {
      logger.e(e);
      if (reqId == lastReqId) {
        Toasts.showErrorToast(
          context: getContext,
          message: getTranslations(getContext).failedToLoadData,
        );
      }
    }
    if (reqId == lastReqId) {
      graphLoaded.value = true;
    }
  }

  String getWeek(DateTime date) {
    final strings = getTranslations(getContext);
    final weekNumber = date.weekNumber;
    return "${strings.week} $weekNumber";
  }

  String getMonth(DateTime date) {
    final strings = getTranslations(getContext);
    final month = switch (date.month) {
      1 => strings.january,
      2 => strings.february,
      3 => strings.march,
      4 => strings.april,
      5 => strings.may,
      6 => strings.june,
      7 => strings.july,
      8 => strings.august,
      9 => strings.september,
      10 => strings.october,
      11 => strings.november,
      12 => strings.december,
      _ => strings.unknown,
    };
    return month;
  }

  getInterval(
      {required DateTime startDate,
      required DateTime endDate,
      FetchType? fetchType,
      double? width}) {
    final intervalByFetchTime = {
      FetchType.all: 1,
      FetchType.seconds: 1000,
      FetchType.minutes: 60000,
      FetchType.hours: 3600000,
      FetchType.days: 86400000,
      FetchType.weeks: 604800000,
      FetchType.months: 2592000000,
      FetchType.years: 31536000000,
    };
    final _fetchType =
        graphType.value!.supportsFetchType ? fetchType! : FetchType.days;
    int numberToSkip = 1;
    int maxDisplayable = 25;
    if (width != null) {
      maxDisplayable = (width / 50).floor();
    }
    final diff =
        endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch;
    final numberOfPoints = (diff / intervalByFetchTime[_fetchType]!).ceil();

    if (numberOfPoints > maxDisplayable) {
      numberToSkip = (numberOfPoints / maxDisplayable).floor();
    }

    logger.e(
        "interval: ${intervalByFetchTime[_fetchType]! * numberToSkip}, skip: $numberToSkip");
    return intervalByFetchTime[_fetchType]! * numberToSkip;
  }

  getLeftInterval() {
    if (minY == maxY) {
      return 1;
    }
    logger.e(
        "minY: $minY, maxY: $maxY, diff: ${maxY! - minY!}, interval: ${((maxY! - minY!) / 10).ceilToDouble()}");
    return ((maxY! - minY!) / 10).ceilToDouble();
  }

  getBackgroundColor() {
    return Theme.of(getContext).colorScheme.surfaceContainer;
  }
}
