import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';

class ThemeModeController extends GetxController {
  ThemeModeController() {
    // Constructor
    loadThemeMode();
  }

  // Properties
  Rx<bool> isDark = false.obs;
  Rx<ThemeMode> get themeMode =>
      isDark.value ? ThemeMode.dark.obs : ThemeMode.light.obs;
  // Methods
  void toggleTheme() {
    isDark.value = !isDark.value;
    LocalStorage.setDarkThemeMode(isDark.value);
  }

  void loadThemeMode() {
    LocalStorage.getDarkThemeMode().then((value) {
      if (value == null) {
        isDark.value = ThemeMode.system == ThemeMode.dark;
        themeMode.value = ThemeMode.system;
        LocalStorage.setDarkThemeMode(isDark.value);
        return;
      }
      isDark.value = value;
    });
  }
}
