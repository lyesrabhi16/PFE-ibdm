import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isDarkModeOn() {
  return Theme.of(Get.context!).brightness == Brightness.dark;
}
