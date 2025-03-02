import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class Cuve extends StatelessWidget {
  const Cuve({
    super.key,
    this.title = "Title",
    this.value = 0,
    this.niveau2 = 0,
    this.niveau1 = 0,
    this.niveau1Trailing = "L",
    this.niveau2Trailing = "KG",
    this.okColor = AppColors.successColor,
    this.dangerColor = AppColors.errorColor,
    this.dangerPoint = 10,
    this.height = 250,
    this.padding = AppSizes.md,
  });

  final String title;
  final double value;
  final double niveau1;
  final double niveau2;
  final String niveau1Trailing;
  final String niveau2Trailing;
  final Color okColor;
  final Color dangerColor;
  final double dangerPoint;
  final double height;
  final double padding;
  Color get color => value > dangerPoint ? okColor : dangerColor;

  @override
  Widget build(BuildContext context) {
    double _value = value <= 100 ? value : 100;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: color,
                          ),
                        ).marginAll(AppSizes.sm),
                        FittedBox(
                          child: Text(
                            "${niveau1.toStringAsFixed(2)} ${niveau1Trailing}",
                            softWrap: false,
                            style: TextStyle(
                              color: color,
                            ),
                          ).marginAll(AppSizes.sm),
                        ),
                        FittedBox(
                          child: Text(
                            "${niveau2.toStringAsFixed(2)} ${niveau2Trailing}",
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
                    value: _value,
                    isInteractive: true,
                    pointerPosition: PointerPosition.left,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${value.toStringAsFixed(2)}%",
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.bold),
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
                  end: _value,
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
