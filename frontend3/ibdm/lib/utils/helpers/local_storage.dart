import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibdm/services/api/api_client/models/user.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum storageKeys {
  locale,
  darkThemeMode,
  user,
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

  static Future<void> setUser(User user) async {
    return perfs.setString(storageKeys.user.name, jsonEncode(user));
  }

  static Future<void> removeUser() async {
    return perfs.remove(storageKeys.user.name);
  }

  static Future<User?> getUser() async {
    try {
      final String? userStr = await perfs.getString(storageKeys.user.name);
      if (userStr == null) {
        return null;
      }
      final userJson = jsonDecode(userStr);

      return User.fromJson(userJson);
    } catch (e) {
      logger.e("Error getting user from local storage: $e");
      return null;
    }
  }
}
