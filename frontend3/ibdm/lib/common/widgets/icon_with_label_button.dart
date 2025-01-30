import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class IconWithLabelButton extends StatelessWidget {
  IconWithLabelButton({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.active = false,
  });

  final Function? onTap;
  final IconData icon;
  final String text;
  final Rx<bool> _hover = false.obs;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (active) {
      _hover.value = true;
    }
    return ShadButton.ghost(
      width: context.width,
      foregroundColor: _hover.value
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSurface,
      backgroundColor:
          _hover.value ? Theme.of(context).colorScheme.primaryContainer : null,
      hoverBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
      hoverForegroundColor: Theme.of(context).colorScheme.onPrimary,
      onHoverChange: (value) => active ? null : _hover.value = value,
      onPressed: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Icon(icon,
                color: _hover.value
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(width: AppSizes.sm),
          Text(text, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
