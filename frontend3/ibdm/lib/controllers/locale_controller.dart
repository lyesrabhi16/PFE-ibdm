import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class LocaleController extends GetxController {
  LocaleController() {
    // Constructor
    loadLocale();
  }

  Rx<Locale> locale = AppLocalizations.supportedLocales.first.obs;
  final supportedLocales = AppLocalizations.supportedLocales;
  final localizationsDelegates = AppLocalizations.localizationsDelegates;
  void setLocale(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    // save the new locale to shared preferences
    LocalStorage.setLocale(newLocale);
    logger
        .i('LocaleController Language changed to ${locale.value.languageCode}');
  }

  void loadLocale() async {
    final Locale? savedLocale = await LocalStorage.getLocale();
    if (savedLocale != null) {
      locale.value = savedLocale;
    }
    LocalStorage.setLocale(locale.value);
  }
}
