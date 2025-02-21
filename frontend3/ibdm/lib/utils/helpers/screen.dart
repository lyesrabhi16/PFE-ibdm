import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';

bool isLargeScreen(BuildContext context) {
  return context.width >= ScreenSizes.lg;
}

bool isMediumScreen(BuildContext context) {
  return context.width >= ScreenSizes.md && context.width < ScreenSizes.lg;
}

bool isSmallScreen(BuildContext context) {
  return context.width >= ScreenSizes.sm && context.width < ScreenSizes.md;
}

bool isExtraSmallScreen(BuildContext context) {
  return context.width < ScreenSizes.sm;
}

bool isAtLeastSmallScreen(BuildContext context) {
  return context.width >= ScreenSizes.sm;
}

bool isAtLeastMediumScreen(BuildContext context) {
  return context.width >= ScreenSizes.md;
}

bool isAtLeastLargeScreen(BuildContext context) {
  return context.width >= ScreenSizes.lg;
}

bool isAtMostSmallScreen(BuildContext context) {
  return context.width < ScreenSizes.md;
}

bool isAtMostMediumScreen(BuildContext context) {
  return context.width < ScreenSizes.lg;
}
