import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color primaryColorDark = Color(0xFF303F9F);
  static const Color primaryColorLight = Color(0xFFC5CAE9);
  static const Color accentColor = Color(0xFF00BCD4);
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color scaffoldBackgroundColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color infoColor = Color(0xFF1976D2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);

  static Color invertColorIfNeeded(Color color) {
    // Calculate the luminance to determine if it's a dark color
    double luminance =
        (0.299 * color.r + 0.587 * color.g + 0.114 * color.b) / 255;

    // If it's too dark, return a lighter version
    return luminance < 0.5 && Get.isDarkMode
        ? Color.fromARGB(color.a.toInt(), 255 - color.r.toInt(),
            255 - color.g.toInt(), 255 - color.b.toInt())
        : color; // Keep it unchanged if it's already bright enough
  }

  static Color getColorFromString(String input,
      {Color backgroundColor = Colors.white}) {
    final int hash = input.hashCode;
    int red = (hash & 0xFF0000) >> 16;
    int green = (hash & 0x00FF00) >> 8;
    int blue = hash & 0x0000FF;

    // If the color is too light, darken it (for light backgrounds)
    final luminance = 0.299 * red + 0.587 * green + 0.114 * blue;
    if (backgroundColor.computeLuminance() > 0.5 && luminance > 200) {
      // Darken the color
      red = (red * 0.5).round();
      green = (green * 0.5).round();
      blue = (blue * 0.5).round();
    } else if (backgroundColor.computeLuminance() <= 0.5 && luminance < 100) {
      // Lighten the color for dark backgrounds
      red = ((255 - red) * 0.5 + red).round();
      green = ((255 - green) * 0.5 + green).round();
      blue = ((255 - blue) * 0.5 + blue).round();
    }

    return Color.fromARGB(255, red, green, blue);
  }

  static Color getRoleColorWithRole(Role role) {
    int colorValue = int.parse("FF${role.color.split("#")[1]}", radix: 16);
    return invertColorIfNeeded(Color(colorValue));
  }

  static Color getRoleColorWithRoleValue(String role) {
    UserController userController = Get.find();
    Role? roleObj = userController.roles.firstWhereOrNull(
      (element) => element.name == role,
    );
    return invertColorIfNeeded(
        roleObj != null ? getRoleColorWithRole(roleObj) : Colors.grey);
  }
}
