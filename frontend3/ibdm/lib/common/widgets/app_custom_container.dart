import 'package:flutter/material.dart';
import 'package:ibdm/common/widgets/drawer_container.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/utils/helpers/screen.dart';

class AppCustomContainer extends StatelessWidget {
  const AppCustomContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isSmallScreen(context)
            ? DrawerContainer(child: child)
            : SideMenuContainer(child: child),
      ),
    );
  }
}
