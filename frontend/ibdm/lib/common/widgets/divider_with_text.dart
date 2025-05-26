import 'package:flutter/material.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, required this.text, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    printMessage("DividerWithText: $text");
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Divider(
            color: color ?? Theme.of(context).colorScheme.onSurface,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
        ),
        FittedBox(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color ?? Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        Expanded(
          child: Divider(
            color: color ?? Theme.of(context).colorScheme.onSurface,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
        ),
      ],
    );
  }
}
