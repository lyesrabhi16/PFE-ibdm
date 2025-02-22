import 'package:flutter/material.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomContainer(
      child: Center(
        child: Text("Page: Settings"),
      ),
    );
  }
}
