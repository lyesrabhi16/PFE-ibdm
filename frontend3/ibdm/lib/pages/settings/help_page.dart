import 'package:flutter/material.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomContainer(
      child: Center(
        child: Text(
          "page Help",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
