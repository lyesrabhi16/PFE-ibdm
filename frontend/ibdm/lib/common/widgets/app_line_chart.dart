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
  final bool includesX;
  final bool includesY;
  final bool includesXMax;
  final bool includesXMin;
  final bool includesYMax;
  final bool includesYMin;

  late final Map graphData;
  final Future<Map> Function(DateTime start, DateTime end, FetchType? fetchType)
      getGraphData;

  GraphType({
    required this.name,
    required this.getGraphData,
    this.ySuffix = " L",
    this.supportsFetchType = true,
    Map? graphData,
    this.includesX = true,
    this.includesY = true,
    this.includesXMax = false,
    this.includesXMin = false,
    this.includesYMax = false,
    this.includesYMin = false,
  }) {
    this.graphData = graphData ?? {};
  }
}

class ChartTooltipData {
  final String title;
  final String value;
  final String date;
  final String time;
  final Color color;

  ChartTooltipData({
    required this.title,
    required this.value,
    required this.date,
    required this.time,
    required this.color,
  });
}

class AppLineChart extends StatelessWidget {
  final List<GraphType> graphTypes;
  final bool isLive;
  final DateTime? liveDate;
  final double height;

  AppLineChart({
    super.key,
    required this.graphTypes,
    this.isLive = false,
    this.liveDate,
    this.height = 600,
  });

  final GlobalKey _chartKey = GlobalKey();
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
  late final Rx<GraphType?> graphType;

  double? minY;
  double? maxY;

  late final RxBool graphLoaded;
  final Map graphData = {};

  int skip = 0;
  String get ySuffix => graphType.value!.ySuffix;
  String? lastReqId;

  // Tooltip overlay variables
  final tooltipNotifier = ValueNotifier<List<ChartTooltipData>?>(null);
  final tooltipPositionNotifier = ValueNotifier<Offset?>(null);
  final OverlayPortalController _tooltipController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    printMessage("Building AppLineChart");
    if (graphTypes.isEmpty) {
      return const SizedBox.shrink();
    }
    graphType = Rx<GraphType?>(graphTypes.isEmpty ? null : graphTypes.first);
    graphLoaded = RxBool(isLive);
    if (isLive && graphType.value != null) {
      graphData.clear();
      graphData.addEntries(graphType.value!.graphData.entries);
    }

    final strings = getTranslations(context).obs;
    printMessage("Graph type: ${graphType.value?.name}");
    return Obx(() {
      fetchType = graphType.value!.supportsFetchType
          ? fetchType ?? FetchType.hours
          : null;
      if (graphData.isEmpty && !graphLoaded.value && !isLive) {
        lastReqId = getUniqueId();
        _getGraphData(reqId: lastReqId!);
      }
      return Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!isLive) ...[
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(),
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
            ],
            SizedBox(height: AppSizes.md),
            DividerWithText(
                text: isLive
                    ? DateFormat("dd-MM-yyyy HH:mm:ss").format(liveDate!)
                    : "${graphType.value!.name.toUpperCase()} ${dateTimeRangeToString(
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
                    height: height,
                    child: CircularProgressIndicatorWithText(
                      text: strings.value.loading,
                    ),
                  )
                : graphData.isEmpty
                    ? SizedBox(
                        height: height,
                        child: Center(
                          child: Text(strings.value.dataNotFound),
                        ),
                      )
                    : _buildChart(context, strings.value),
          ],
        ),
      );
    });
  }

  Widget _buildChart(BuildContext context, dynamic strings) {
    printMessage("Building chart");
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

      try {
        first ??= e.value.first["x"].toDouble();
        last ??= e.value.last["x"].toDouble();
        minY ??= e.value.first["y"].toDouble();
        maxY ??= e.value.last["y"].toDouble();
      } catch (err) {
        // Handle error
      }
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
        spots[e.key].add(FlSpot(d["x"].toDouble(), d["y"].toDouble()));
      }
    }

    final shownXTitles = <String>[];
    final shownXValues = <double>[];
    double width = context.width;
    printMessage("Width: $width, Height: ${context.height}");
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          width = constraints.maxWidth;
          printMessage(
              "LayoutBuilder width: $width, height: ${constraints.maxHeight}");
          return Builder(builder: (context) {
            return OverlayPortal(
              controller: _tooltipController,
              overlayChildBuilder: (context) {
                printMessage("Building overlay child");
                return Stack(
                  children: [
                    ValueListenableBuilder<Offset?>(
                      valueListenable: tooltipPositionNotifier,
                      builder: (context, position, child) {
                        if (position == null) return const SizedBox.shrink();
                        printMessage("Position: $position");

                        return Positioned(
                          left: position.dx,
                          top: position.dy,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(8),
                            child: child!,
                          ),
                        );
                      },
                      child: ValueListenableBuilder<List<ChartTooltipData>?>(
                        valueListenable: tooltipNotifier,
                        builder: (context, tooltipData, _) {
                          printMessage(
                              "Building tooltip with data: $tooltipData");
                          if (tooltipData == null || tooltipData.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLowest,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...tooltipData.map((data) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: data.color,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${data.title}: ${data.value}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: data.color,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          if (tooltipData.indexOf(data) ==
                                              tooltipData.length - 1) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              data.date,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            Text(
                                              data.time,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              child: Builder(builder: (context) {
                printMessage("Building chart widget");
                return SizedBox(
                  width: context.width,
                  height: context.height / 2,
                  child: GestureDetector(
                    onTapDown: (_) {
                      _hideTooltip();
                    },
                    onPanStart: (_) {
                      _hideTooltip();
                    },
                    child: Builder(builder: (context) {
                      printMessage("Building MouseRegion");
                      return MouseRegion(
                        onExit: (event) => _hideTooltip(),
                        child: KeyedSubtree(
                          key: _chartKey,
                          child: Builder(builder: (context) {
                            printMessage("Building LineChart");
                            return LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  verticalInterval: getInterval(
                                    startDate: startDate,
                                    endDate: endDate,
                                    fetchType: fetchType,
                                    width: width,
                                  ),
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
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (v) => Colors.transparent,
                                    tooltipPadding: EdgeInsets.zero,
                                    tooltipMargin: 0,
                                    getTooltipItems: (v) => [
                                      for (var item in v)
                                        LineTooltipItem("", TextStyle())
                                    ],
                                  ),
                                  touchCallback: (FlTouchEvent event,
                                      LineTouchResponse? touchResponse) async {
                                    final touchedSpots =
                                        touchResponse?.lineBarSpots!;
                                    final localPosition =
                                        (event as dynamic).localPosition;

                                    if ([
                                          FlTouchEvent,
                                          FlPanDownEvent,
                                          FlTapDownEvent,
                                          FlPanStartEvent,
                                          FlPointerEnterEvent,
                                          FlPointerHoverEvent,
                                          FlTapUpEvent,
                                          FlPanEndEvent,
                                          FlPanUpdateEvent,
                                        ].contains(event.runtimeType) &&
                                        touchedSpots != null) {
                                      logger.e("show tooltip");
                                      // Get the correct context for the chart widget
                                      final chartContext =
                                          _chartKey.currentContext;
                                      if (chartContext != null) {
                                        _showTooltip(chartContext, touchedSpots,
                                            localPosition);
                                      }
                                      return;
                                    }

                                    _hideTooltip();
                                    return;
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    drawBelowEverything: true,
                                    sideTitles: SideTitles(
                                      showTitles: graphType.value!.includesY,
                                      maxIncluded:
                                          graphType.value!.includesYMax,
                                      minIncluded:
                                          graphType.value!.includesYMin,
                                      reservedSize: 100,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                            NumberFormat.compactCurrency(
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
                                      showTitles: graphType.value!.includesX,
                                      maxIncluded:
                                          graphType.value!.includesXMax,
                                      minIncluded:
                                          graphType.value!.includesXMin,
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
                                          value.toInt(),
                                        );
                                        if (shownXValues.isNotEmpty) {
                                          final _date = switch (fetchType) {
                                            FetchType.hours => DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                date.hour),
                                            FetchType.days => DateTime(
                                                date.year,
                                                date.month,
                                                date.day),
                                            FetchType.weeks => DateTime(
                                                date.year,
                                                date.month,
                                                date.day),
                                            FetchType.months =>
                                              DateTime(date.year, date.month),
                                            FetchType.years =>
                                              DateTime(date.year),
                                            _ => DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                date.hour,
                                                date.minute),
                                          };
                                          final dateDiff = _date
                                              .difference(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      shownXValues.last
                                                          .toInt()))
                                              .inMilliseconds;

                                          if (dateDiff <=
                                              (getInterval(
                                                startDate: startDate,
                                                endDate: endDate,
                                                fetchType: fetchType,
                                                width: width,
                                              ))) {
                                            return const SizedBox.shrink();
                                          }
                                        }

                                        String formattedDate =
                                            switch (fetchType) {
                                          FetchType.hours => DateFormat(
                                                  endDate.day == startDate.day
                                                      ? "HH:mm"
                                                      : "dd/MM/yyyy HH:mm")
                                              .format(date),
                                          FetchType.days =>
                                            DateFormat("dd/MM/yyyy")
                                                .format(date),
                                          FetchType.weeks => getWeek(date),
                                          FetchType.months => getMonth(date),
                                          FetchType.years =>
                                            date.year.toString(),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                      dotData: const FlDotData(show: false),
                                      color: AppColors.getColorFromString(
                                        e.key,
                                        backgroundColor: getBackgroundColor(),
                                      ),
                                      curveSmoothness: 0.5,
                                      preventCurveOverShooting: true,
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.getColorFromString(
                                          e.key,
                                          backgroundColor: getBackgroundColor(),
                                        ).withAlpha(50),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                );
              }),
            );
          });
        },
      ),
    );
  }

  void _showTooltip(
    BuildContext context,
    List<LineBarSpot> touchedSpots,
    Offset localPosition,
  ) {
    // Get the RenderBox of the chart widget
    final RenderBox chartBox =
        context.findAncestorRenderObjectOfType<RenderBox>()!;

    // Convert local position to global coordinates
    final globalPosition = chartBox.localToGlobal(Offset(0, 0));

    // Get the overlay's RenderBox
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Convert global position to overlay-local coordinates
    final overlayPosition = overlay.globalToLocal(globalPosition);

    final tooltipItems = <ChartTooltipData>[];
    final screenSize = MediaQuery.of(context).size;

    for (var spot in touchedSpots) {
      final x = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
      final y = spot.y;
      final key = graphData.keys.elementAt(spot.barIndex);

      tooltipItems.add(
        ChartTooltipData(
          title: key,
          value: NumberFormat.compactCurrency(
            decimalDigits: 2,
            locale: "fr",
            symbol: ySuffix,
          ).format(y),
          date:
              "${x.day.toString().padLeft(2, "0")}/${x.month.toString().padLeft(2, "0")}/${x.year.toString().padLeft(2, "0")}",
          time:
              "${x.hour.toString().padLeft(2, "0")}:${x.minute.toString().padLeft(2, "0")}:${x.second.toString().padLeft(2, "0")}",
          color: AppColors.getColorFromString(
            key,
            backgroundColor: getBackgroundColor(),
          ),
        ),
      );
    }

    // Calculate tooltip position (relative to overlay)
    double xPosition = overlayPosition.dx;
    double yPosition = overlayPosition.dy - 100; // Position above touch point

    // Ensure tooltip stays within screen bounds
    if (xPosition + 200 > screenSize.width) {
      xPosition = screenSize.width - 200;
    }
    if (xPosition < 0) {
      xPosition = 0;
    }
    if (yPosition < 0) {
      yPosition = overlayPosition.dy + 20;
    }

    tooltipNotifier.value = tooltipItems;
    tooltipPositionNotifier.value = Offset(xPosition, yPosition);
    if (!_tooltipController.isShowing) {
      _tooltipController.show();
    }
  }

  void _hideTooltip() {
    printMessage('Hiding tooltip');
    _tooltipController.hide();
    tooltipNotifier.value = null;
    tooltipPositionNotifier.value = null;
  }

  Future<void> _getGraphData({
    required String reqId,
  }) async {
    graphLoaded.value = false;
    lastReqId = reqId;
    try {
      graphData.clear();
      final res =
          await graphType.value!.getGraphData(startDate, endDate, fetchType);
      if (reqId == lastReqId) {
        graphData.addEntries(res.entries);
      }
    } catch (e) {
      logger.e(e);
      if (reqId == lastReqId) {
        Toasts.showErrorToast(
          context: Get.context!,
          message: getTranslations(Get.context!).failedToLoadData,
        );
      }
    }
    if (reqId == lastReqId) {
      graphLoaded.value = true;
    }
  }

  String getWeek(DateTime date) {
    printMessage("Getting week for date: $date");
    final strings = getTranslations(Get.context!);
    final weekNumber = date.weekNumber;
    printMessage("Week number: $weekNumber");
    return "${strings.week} $weekNumber";
  }

  String getMonth(DateTime date) {
    printMessage("Getting month for date: $date");
    final strings = getTranslations(Get.context!);
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
    printMessage("Month: $month");
    return month;
  }

  getInterval({
    required DateTime startDate,
    required DateTime endDate,
    FetchType? fetchType,
    double? width,
  }) {
    printMessage("getting interval for fetchType: $fetchType, width: $width");
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
    printMessage(
        "Interval for fetchType: $_fetchType, numberToSkip: $numberToSkip");
    final calc = intervalByFetchTime[_fetchType]! * numberToSkip;
    printMessage("Calculated interval: $calc");
    return calc.toDouble();
  }

  getLeftInterval() {
    printMessage("Getting left interval for Y axis");
    if (minY == maxY) {
      return 1;
    }
    printMessage("MinY: $minY, MaxY: $maxY");
    return ((maxY! - minY!) / 10).ceilToDouble();
  }

  getBackgroundColor() {
    return Theme.of(Get.context!).colorScheme.surfaceContainer;
  }
}
