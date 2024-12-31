import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum storageKeys {
  locale,
  darkThemeMode,
}

class LocalStorage {
  LocalStorage._();

  static final SharedPreferencesAsync perfs = SharedPreferencesAsync();

  static final LocalStorage instance = LocalStorage._();

  static Future<void> setLocale(Locale locale) async {
    return perfs.setString(storageKeys.locale.name, locale.languageCode);
  }

  static Future<Locale?> getLocale() async {
    final String? locale = await perfs.getString(storageKeys.locale.name);
    if (locale == null) {
      return null;
    }
    return Locale(locale);
  }

  static Future<void> setDarkThemeMode(bool isDark) async {
    return perfs.setBool(storageKeys.darkThemeMode.name, isDark);
  }

  static Future<bool?> getDarkThemeMode() async {
    return perfs.getBool(storageKeys.darkThemeMode.name);
  }
}
