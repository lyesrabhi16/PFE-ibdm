import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/sizes.dart';

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
        child: ListTile(
          leading: Icon(icon, color: Colors.blueAccent),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
