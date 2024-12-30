import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';

bool isLargeScreen(BuildContext context) {
  return context.width >= ScreenSizes.lg;
}

bool isMediumScreen(BuildContext context) {
  return context.width >= ScreenSizes.md;
}

bool isSmallScreen(BuildContext context) {
  return context.width < ScreenSizes.md;
}

bool isExtraSmallScreen(BuildContext context) {
  return context.width < ScreenSizes.sm;
}
