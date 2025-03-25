import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/actions_row.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // build nav destinations(buttons)
    final items = [];
    for (Destination dest in Destination.getDestinations(context)) {
      items.add(
        IconWithLabelButton(
          icon: dest.icon,
          text: dest.title,
          active: (() {
            return Get.currentRoute == dest.route;
          })(),
          onTap: () {
            Navigator.of(context).pop();
            Get.toNamed(dest.route);
            SideMenuContainer.onNavigationChanged(
              index: dest.index,
              route: dest.route,
            );
          },
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    showShadSheet(
                      context: context,
                      side: ShadSheetSide.left,
                      builder: (context) => ShadSheet(
                        constraints: BoxConstraints(
                            minWidth: min(300, context.width * 0.8),
                            maxWidth: min(300, context.width * 0.8)),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                        titleTextAlign: TextAlign.center,
                        actions: [ActionsRow()],
                        actionsMainAxisAlignment: MainAxisAlignment.center,
                        closeIcon: IconButton(
                          icon: Icon(
                            LucideIcons.x,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        title: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  width: AppSizes.xl * 5,
                                  height: AppSizes.xl * 5,
                                ),
                              ),
                              FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(AppSizes.sm / 2),
                                  child: Text(
                                    "IBDM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                              Text("Ifri Base de Données Machines",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              SizedBox(height: AppSizes.md),
                              ShadButton.destructive(
                                width: context.width,
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  Get.find<UserController>().logoutUser();
                                  Get.offAllNamed(Routes.login);
                                },
                                child: FittedBox(child: Text("Logout")),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...items,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Text("IBDM"),
              ],
            ),
            ActionsRow(),
          ],
        ),
        Expanded(child: child)
      ],
    );
  }
}
