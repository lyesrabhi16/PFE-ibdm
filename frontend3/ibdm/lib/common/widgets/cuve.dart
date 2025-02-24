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
