import 'package:flutter/material.dart';
import 'package:ibdm/services/api/api_client/export.dart';

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

  // gold color in hex
  static const Color roleAdminSystemColor = Color(0xFFD4AF37);
  static const Color roleAdminColor = Colors.deepPurple;
  static const Color roleSupervisorColor = Colors.green;
  static const Color roleOperateurColor = Colors.blue;

  static Color getRoleColor(Role role) {
    switch (role) {
      case Role.adminSystem:
        return roleAdminSystemColor;
      case Role.admin:
        return roleAdminColor;
      case Role.supervisor:
        return roleSupervisorColor;
      case Role.operateur:
        return roleOperateurColor;
      default:
        return Colors.transparent;
    }
  }
}
