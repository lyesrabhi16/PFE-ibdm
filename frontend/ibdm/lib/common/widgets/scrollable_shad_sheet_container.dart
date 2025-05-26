import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ScrollableShadSheetContainer extends StatelessWidget {
  const ScrollableShadSheetContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShadSheet(
      scrollable: false,
      closeIconPosition: ShadPosition(
        top: AppSizes.lg,
        right: AppSizes.md,
      ),
      child: Container(
        constraints: BoxConstraints(
          minWidth: min(context.width / 2, 300),
          maxWidth: context.width,
          minHeight: context.height,
          maxHeight: context.height,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.invertedStylus,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.unknown,
                },
                scrollbars: true, // This enables scrollbars
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: SingleChildScrollView(
                  primary: true,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.md * 2),
                    child: child ?? Placeholder(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
