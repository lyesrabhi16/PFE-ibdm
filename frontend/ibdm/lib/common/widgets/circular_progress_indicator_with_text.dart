import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class CircularProgressIndicatorWithText extends StatelessWidget {
  const CircularProgressIndicatorWithText({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: AppSizes.md),
        FittedBox(
          child: Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    ));
  }
}
