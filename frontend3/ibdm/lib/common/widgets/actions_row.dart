import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key, this.wrap = false});
  final bool wrap;
  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      IntrinsicWidth(child: ThemeModeSwitchButton()),
      IntrinsicWidth(child: LanguageSwitchButton()),
    ];

    return wrap
        ? SizedBox(
            width: context.width,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: AppSizes.md,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: AppSizes.sm,
              children: items,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSizes.md,
            children: items,
          );
  }
}
