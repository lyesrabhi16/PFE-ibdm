import 'package:flutter/material.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomContainer(
      child: Center(
        child: Text(
          "page About",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
