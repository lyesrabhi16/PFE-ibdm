import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: AppSizes.xl,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: AppSizes.lg,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: AppSizes.md,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: TextStyle().copyWith(
      fontSize: AppSizes.lg,
      color: Colors.black,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: AppSizes.md,
      color: Colors.black,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: AppSizes.sm,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: AppSizes.xl,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: AppSizes.lg,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: AppSizes.md,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: TextStyle().copyWith(
      fontSize: AppSizes.lg,
      color: Colors.white,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: AppSizes.md,
      color: Colors.white,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: AppSizes.sm,
      color: Colors.white,
    ),
  );
}
