import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleTextStyle,
    this.onLongPress,
  });

  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
        child: ListTile(
          leading: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
          title: Text(
            title,
            style: titleTextStyle,
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
