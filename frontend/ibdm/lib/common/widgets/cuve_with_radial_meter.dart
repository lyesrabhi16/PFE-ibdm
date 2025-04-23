import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/cuve.dart';
import 'package:ibdm/common/widgets/radial_meter.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class CuveWithRadialMeter extends StatelessWidget {
  const CuveWithRadialMeter({
    super.key,
    this.cuve,
    this.radialMeter,
    this.title = "Title",
  });

  final Cuve? cuve;
  final RadialMeter? radialMeter;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 600 - (cuve == null ? 300 : 0) - (radialMeter == null ? 300 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cuve != null) cuve!,
          if (radialMeter != null)
            radialMeter!.marginOnly(
              left: 60,
            ),
          Align(
            child: Text(title).marginOnly(
              left: 60,
            ),
          ),
        ],
      ),
    );
  }
}
