import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        children: [
          Divider(
            color: Theme.of(context).colorScheme.onSurface,
            indent: 10,
            endIndent: 10,
          ),
          Text(text),
          Divider(
            color: Theme.of(context).colorScheme.onSurface,
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
    );
  }
}
