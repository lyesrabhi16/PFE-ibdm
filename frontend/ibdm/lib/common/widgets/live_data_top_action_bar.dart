import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class LiveDataTopActionBar extends StatelessWidget {
  final RxBool isLive;

  final DateTime? selectedDate;
  final DateTime startDate;
  final DateTime endDate;

  final List<Widget>? afterDataDisplayWidgets;

  final List<Widget>? beforeDataDisplayWidgets;
  final Function? graphPressed;
  final Function? listPressed;

  LiveDataTopActionBar({
    super.key,
    required this.isLive,
    required this.startDate,
    required this.endDate,
    this.selectedDate,
    this.beforeDataDisplayWidgets,
    this.afterDataDisplayWidgets,
    this.searchPressed,
    this.graphPressed,
    this.listPressed,
  });

  Function(DateTime dateTime)? searchPressed;

  Function? _getContext;

  BuildContext get context => _getContext!.call()!;

  Color _getBackgroundColor(bool active) {
    return active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerLow;
  }

  Color _getForgroundColor(bool active) {
    return active
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;
  }

  String _getTimeString(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, "0")}:${dt.minute.toString().padLeft(2, "0")}:${dt.second.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    final _textColor = _getForgroundColor(!isLive.value).obs;
    final _selectedDate = selectedDate.obs;

    return Obx(
      () {
        //logger.e("isLive: ${isLive.value}");
        //logger.e("selectedDate: ${_selectedDate.value}");
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
                child: Text(
                  isLive.value
                      ? strings.value.showingLiveData
                      : strings.value.showLiveData,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // date
                  ShadDatePicker(
                      width: 160,
                      height: 40,
                      allowDeselection: false,
                      backgroundColor: _getBackgroundColor(!isLive.value),
                      hoverBackgroundColor: _getBackgroundColor(isLive.value),
                      foregroundColor: _getForgroundColor(!isLive.value),
                      hoverForegroundColor: _getForgroundColor(isLive.value),
                      enabled: !isLive.value,
                      icon: Icon(LucideIcons.calendar, size: 16),
                      formatDate: (d) => "${d.day}/${d.month}/${d.year}",
                      mainAxisAlignment: MainAxisAlignment.center,
                      selectableDayPredicate: (day) =>
                          day.isSameDayOrGreatier(startDate) &&
                          day.isSameDayOrLower(endDate),
                      selected: selectedDate,
                      buttonVariant: ShadButtonVariant.ghost,
                      onChanged: (d) => _selectedDate.value = d!.copyWith(
                            hour: _selectedDate.value?.hour ?? 0,
                            minute: _selectedDate.value?.minute ?? 0,
                            second: _selectedDate.value?.second ?? 0,
                          )).marginSymmetric(
                    horizontal: AppSizes.sm,
                  ),
                  // time
                  ShadButton(
                      width: 160,
                      height: 40,
                      backgroundColor: _getBackgroundColor(!isLive.value),
                      hoverBackgroundColor: _getBackgroundColor(isLive.value),
                      foregroundColor: _getForgroundColor(!isLive.value),
                      hoverForegroundColor: _getForgroundColor(isLive.value),
                      enabled: !isLive.value,
                      onHoverChange: (hovered) => {
                            _textColor.value = _getForgroundColor(
                                hovered ? isLive.value : !isLive.value),
                          },
                      icon: Icon(
                        LucideIcons.clock,
                        size: 16,
                      ),
                      child: Text(
                        _getTimeString(_selectedDate.value!),
                        textAlign: TextAlign.center,
                        softWrap: false,
                      ),
                      onPressed: () {
                        showShadDialog(
                            context: context,
                            builder: (context) => ShadDialog(
                                  child: Center(
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context)
                                          .copyWith(
                                        dragDevices:
                                            PointerDeviceKind.values.toSet(),
                                        scrollbars: false,
                                      ),
                                      child: TimePickerSpinner(
                                        is24HourMode: true,
                                        isShowSeconds: true,
                                        isForce2Digits: true,
                                        itemWidth: 80,
                                        spacing: AppSizes.md,
                                        alignment: Alignment.center,
                                        onTimeChange: (dt) => {
                                          _selectedDate.value = _selectedDate
                                                      .value !=
                                                  null
                                              ? _selectedDate.value!.copyWith(
                                                  hour: dt.hour,
                                                  minute: dt.minute,
                                                  second: dt.second,
                                                )
                                              : dt,
                                        },
                                        time: _selectedDate.value,
                                      ),
                                    ),
                                  ),
                                ));
                      }).marginSymmetric(
                    horizontal: AppSizes.sm,
                  ),
                ],
              ),
              // show live data
              if (!isLive.value && _selectedDate.value != null)
                ShadButton(
                  width: 140,
                  icon: Icon(
                    LucideIcons.search,
                    size: 16,
                  ),
                  backgroundColor: _getBackgroundColor(!isLive.value),
                  hoverBackgroundColor: !isLive.value
                      ? Theme.of(context).colorScheme.surfaceContainerLow
                      : Theme.of(context).colorScheme.primary,
                  hoverForegroundColor: !isLive.value
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: !isLive.value
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  onPressed: () => searchPressed?.call(
                    _selectedDate.value!,
                  ),
                  child: Text(strings.value.find.capitalize!),
                ),
              ShadButton(
                width: 120,
                icon: Icon(
                  LucideIcons.list,
                  size: 16,
                ),
                onPressed: () => listPressed?.call(),
                child: Text(strings.value.list),
              ),
              ShadButton(
                width: 120,
                icon: Icon(
                  LucideIcons.chartSpline,
                  size: 16,
                ),
                onPressed: () => graphPressed?.call(),
                child: Text(strings.value.graph),
              ),
              if (afterDataDisplayWidgets != null) ...afterDataDisplayWidgets!,
            ],
          ),
        );
      },
    );
  }
}
