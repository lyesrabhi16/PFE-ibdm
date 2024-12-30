import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
          style: ButtonStyle().copyWith(
    backgroundColor: WidgetStateProperty.fromMap({
      WidgetState.pressed: AppColors.accentColor,
      WidgetState.hovered: AppColors.accentColor,
      WidgetState.focused: AppColors.accentColor,
      WidgetState.selected: AppColors.accentColor,
      WidgetState.disabled: AppColors.grey,
    }),
    foregroundColor: WidgetStateProperty.all(AppColors.white),
    textStyle: WidgetStateProperty.all(TextStyle().copyWith(
      fontSize: AppSizes.md,
      fontWeight: FontWeight.bold,
    )),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
      horizontal: AppSizes.md,
      vertical: AppSizes.sm,
    )),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.sm),
    )),
  ));

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
          style: ButtonStyle().copyWith(
    backgroundColor: WidgetStateProperty.fromMap({
      WidgetState.pressed: AppColors.accentColor,
      WidgetState.hovered: AppColors.accentColor,
      WidgetState.focused: AppColors.accentColor,
      WidgetState.selected: AppColors.accentColor,
      WidgetState.disabled: AppColors.grey,
    }),
    foregroundColor: WidgetStateProperty.all(AppColors.black),
    textStyle: WidgetStateProperty.all(TextStyle().copyWith(
      fontSize: AppSizes.md,
      fontWeight: FontWeight.bold,
    )),
    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
      horizontal: AppSizes.md,
      vertical: AppSizes.sm,
    )),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.sm),
    )),
  ));
}
