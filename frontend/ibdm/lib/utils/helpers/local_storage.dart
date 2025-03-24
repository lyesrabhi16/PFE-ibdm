import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeys { locale, darkThemeMode, user, perPage }

class LocalStorage {
  LocalStorage._();

  static final SharedPreferencesAsync perfs = SharedPreferencesAsync();

  static final LocalStorage instance = LocalStorage._();

  static Future<void> setLocale(Locale locale) async {
    return perfs.setString(StorageKeys.locale.name, locale.languageCode);
  }

  static Future<Locale?> getLocale() async {
    final String? locale = await perfs.getString(StorageKeys.locale.name);
    if (locale == null) {
      return null;
    }
    return Locale(locale);
  }

  static Future<void> setDarkThemeMode(bool isDark) async {
    return perfs.setBool(StorageKeys.darkThemeMode.name, isDark);
  }

  static Future<bool?> getDarkThemeMode() async {
    return perfs.getBool(StorageKeys.darkThemeMode.name);
  }

  static Future<void> setUser(User user) async {
    return perfs.setString(
        StorageKeys.user.name, JsonCodec().encode(user.toJson()));
  }

  static Future<void> removeUser() async {
    return perfs.remove(StorageKeys.user.name);
  }

  static Future<User?> getUser() async {
    try {
      final String? userStr = await perfs.getString(StorageKeys.user.name);
      if (userStr == null) {
        return null;
      }
      return User.fromJson(JsonCodec().decode(userStr));
    } catch (e) {
      logger.e("Error getting user from local storage: $e");
      return null;
    }
  }

  static Future<void> setPerPage(int perPage) async {
    return await perfs.setInt(StorageKeys.perPage.name, perPage);
  }

  static Future<int?> getPerPage() async {
    return await perfs.getInt(StorageKeys.perPage.name);
  }
}
