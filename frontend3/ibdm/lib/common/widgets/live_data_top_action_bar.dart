import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LiveDataTopActionBar extends StatelessWidget {
  Function? _getContext;
  BuildContext get context => _getContext!.call()!;
  final RxBool isLive;
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;

  final List<int> years;
  final List<int> months;
  final List<int> days;
  final List<int> hours;
  final List<int> minutes;
  final List<int> seconds;

  Function(int?)? onYearChanged;

  final int? yearInitialValue;
  final int? monthInitialValue;
  final int? dayInitialValue;
  final int? hourInitialValue;
  final int? minuteInitialValue;
  final int? secondInitialValue;

  Function(int?)? onMonthChanged;
  Function(int?)? onDayChanged;
  Function(int?)? onHourChanged;
  Function(int?)? onMinuteChanged;
  Function(int?)? onSecondChanged;

  List<Widget>? afterDataDisplayWidgets;

  List<Widget>? beforeDataDisplayWidgets;

  LiveDataTopActionBar({
    super.key,
    required this.isLive,
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    this.yearInitialValue,
    this.monthInitialValue,
    this.dayInitialValue,
    this.hourInitialValue,
    this.minuteInitialValue,
    this.secondInitialValue,
    this.onYearChanged,
    this.onMonthChanged,
    this.onDayChanged,
    this.onHourChanged,
    this.onMinuteChanged,
    this.onSecondChanged,
    this.beforeDataDisplayWidgets,
    this.afterDataDisplayWidgets,
  });

  _getMonthFromInt(int month) {
    final strings = getTranslations(context).obs;
    switch (month) {
      case 1:
        return strings.value.january;
      case 2:
        return strings.value.february;
      case 3:
        return strings.value.march;
      case 4:
        return strings.value.april;
      case 5:
        return strings.value.may;
      case 6:
        return strings.value.june;
      case 7:
        return strings.value.july;
      case 8:
        return strings.value.august;
      case 9:
        return strings.value.september;
      case 10:
        return strings.value.october;
      case 11:
        return strings.value.november;
      case 12:
        return strings.value.december;
    }
  }

  List<ShadOption> _getMonths() {
    return months
        .map((month) {
          return ShadOption(value: month, child: Text(_getMonthFromInt(month)));
        })
        .nonNulls
        .toList();
  }

  List<ShadOption> _getDays() {
    return days
        .map((day) {
          return ShadOption(value: day, child: Text(day.toString()));
        })
        .nonNulls
        .toList();
  }

  List<ShadOption> _getHours() {
    return hours
        .map((hour) {
          return ShadOption(value: hour, child: Text(hour.toString()));
        })
        .nonNulls
        .toList();
  }

  List<ShadOption> _getMinutes() {
    return minutes
        .map((minute) {
          return ShadOption(value: minute, child: Text(minute.toString()));
        })
        .nonNulls
        .toList();
  }

  List<ShadOption> _getSeconds() {
    return seconds
        .map((second) {
          return ShadOption(value: second, child: Text(second.toString()));
        })
        .nonNulls
        .toList();
  }

  _getBackgroundColor(bool active) {
    return active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerLow;
  }

  _getForgroundColor(bool active) {
    return active
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    _getContext = () => context;

    return Obx(
      () {
        return Padding(
          padding: EdgeInsets.all(AppSizes.sm),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (beforeDataDisplayWidgets != null)
                ...beforeDataDisplayWidgets!,
              // show live data
              ShadButton(
                backgroundColor: _getBackgroundColor(isLive.value),
                hoverBackgroundColor: isLive.value
                    ? Theme.of(context).colorScheme.surfaceContainerLow
                    : Theme.of(context).colorScheme.primary,
                hoverForegroundColor: isLive.value
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onPrimary,
                foregroundColor: isLive.value
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  isLive.value = !isLive.value;
                },
                child: Text(isLive.value
                    ? strings.value.showingLiveData
                    : strings.value.showLiveData),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  // year
                  ShadSelect<int>(
                    enabled: !isLive.value,
                    decoration: ShadDecoration(
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(5),
                        ),
                        color: _getBackgroundColor(!isLive.value),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    options: [
                      for (int year in years)
                        ShadOption(
                          value: year,
                          child: Text(
                            year.toString(),
                          ),
                        ),
                    ],
                    onChanged: onYearChanged,
                    selectedOptionBuilder: (context, option) {
                      return Text(
                        strings.value.year(option),
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                              color: _getForgroundColor(!isLive.value),
                            ),
                      );
                    },
                    initialValue: yearInitialValue,
                  ),
                  // month
                  ShadSelect<int>(
                    enabled: !isLive.value,
                    options: _getMonths(),
                    decoration: ShadDecoration(
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(5),
                        ),
                        color: _getBackgroundColor(!isLive.value),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    onChanged: onMonthChanged,
                    selectedOptionBuilder: (context, option) {
                      return Text(
                        strings.value.month(_getMonthFromInt(option)),
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                              color: _getForgroundColor(!isLive.value),
                            ),
                      );
                    },
                    initialValue: monthInitialValue,
                  ),
                  // day
                  ShadSelect(
                    enabled: !isLive.value,
                    decoration: ShadDecoration(
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(5),
                        ),
                        color: _getBackgroundColor(!isLive.value),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    options: _getDays(),
                    onChanged: onDayChanged,
                    selectedOptionBuilder: (context, option) {
                      return Text(
                        strings.value.day(option.toString()),
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                              color: _getForgroundColor(!isLive.value),
                            ),
                      );
                    },
                    initialValue: dayInitialValue,
                  ),
                  // hour
                  ShadSelect<int>(
                    enabled: !isLive.value,
                    decoration: ShadDecoration(
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(5),
                        ),
                        color: _getBackgroundColor(!isLive.value),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    options: _getHours(),
                    onChanged: onHourChanged,
                    selectedOptionBuilder: (context, option) {
                      return Text(
                        strings.value.hour(option.toString()),
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                              color: _getForgroundColor(!isLive.value),
                            ),
                      );
                    },
                    initialValue: hourInitialValue,
                  ),
                  // minute
                  ShadSelect(
                    enabled: !isLive.value,
                    decoration: ShadDecoration(
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(5),
                        ),
                        color: _getBackgroundColor(!isLive.value),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    options: _getMinutes(),
                    onChanged: onMinuteChanged,
                    selectedOptionBuilder: (context, option) {
                      return Text(
                        strings.value.minute(option.toString()),
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                              color: _getForgroundColor(!isLive.value),
                            ),
                      );
                    },
                    initialValue: minuteInitialValue,
                  ),
                  // second
                  ShadSelect<int>(
                    enabled: !isLive.value,
                    decoration: ShadDecoration(
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(5),
                        ),
                        color: _getBackgroundColor(!isLive.value),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    options: _getSeconds(),
                    onChanged: onSecondChanged,
                    selectedOptionBuilder: (context, option) {
                      return Text(
                        strings.value.second(
                          option.toString(),
                        ),
                        style: TextTheme.of(context).bodyMedium?.copyWith(
                              color: _getForgroundColor(!isLive.value),
                            ),
                      );
                    },
                    initialValue: secondInitialValue,
                  ),
                ],
              ),
              if (afterDataDisplayWidgets != null) ...afterDataDisplayWidgets!,
            ],
          ),
        );
      },
    );
  }
}
