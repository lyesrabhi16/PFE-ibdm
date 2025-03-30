import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:toastification/toastification.dart';

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
