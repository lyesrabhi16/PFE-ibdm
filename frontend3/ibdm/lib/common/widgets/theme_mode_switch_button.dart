import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/theme_mode_controller.dart';

class ThemeModeSwitchButton extends StatelessWidget {
  ThemeModeSwitchButton({super.key});
  final ThemeModeController themeModeController =
      Get.find<ThemeModeController>();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Obx(() => Icon(themeModeController.isDark.value
          ? Icons.dark_mode
          : Icons.light_mode)),
      onPressed: () {
        themeModeController.toggleTheme();
      },
    );
  }
}
