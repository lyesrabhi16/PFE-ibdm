import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:toastification/toastification.dart';

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
    this.showTrack2 = true,
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
  final bool showTrack2;
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
                    if (showTrack2) ...[
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
                    ]
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
                if (showTrack2) ...[
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
                ]
              ],
              widgetPointer: [],
            ),
          ],
        ),
      ),
    );
  }
}
