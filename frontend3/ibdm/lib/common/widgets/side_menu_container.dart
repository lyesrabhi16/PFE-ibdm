import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/actions_row.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SideMenuContainer extends StatelessWidget {
  const SideMenuContainer({super.key, required this.child});

  static final SideMenuController controller = SideMenuController();
  final Widget child;
  static void onItemTap(int index) {
    logger.d("index: $index");
  }

  static bool _added = false;
  static bool _open = true;
  static Rx<SideMenuDisplayMode> displayMode = SideMenuDisplayMode.auto.obs;

  @override
  Widget build(BuildContext context) {
    if (!_added) {
      controller.addListener(onItemTap);
      _added = true;
    }

    // activate current page
    int startIndexOffset = 1; // actual index of the first page in items list
    controller.changePage(Destination.getDestinationsMap(
      context,
      startIndexOffset: startIndexOffset,
    )[Get.currentRoute]!
        .index!);

    List<SideMenuItem> items = [];
    for (Destination dest in Destination.getDestinations(context)) {
      items.add(SideMenuItem(
        icon: Icon(dest.icon),
        title: dest.title,
        onTap: (index, controller) {
          controller.changePage(index);
          Get.toNamed(dest.route);
        },
      ));
    }

    return Obx(
      () {
        return SafeArea(
          child: Scaffold(
            body: Row(
              children: [
                SideMenu(
                  onDisplayModeChanged: (value) =>
                      _open = (value == SideMenuDisplayMode.open),
                  displayModeToggleDuration: Durations.short4,
                  items: [
                    SideMenuItem(
                      builder: (context, controller) {
                        return IntrinsicHeight(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _open
                                      ? Icons.arrow_back_ios_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () {
                                  displayMode.value = _open
                                      ? SideMenuDisplayMode.compact
                                      : SideMenuDisplayMode.open;
                                  _open = !_open;
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(AppSizes.sm),
                                child: ActionsRow(
                                  wrap: true,
                                ),
                              ),
                              ShadButton.destructive(
                                width: context.width,
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  Get.find<UserController>().logoutUser();
                                  Get.offAllNamed(Routes.login);
                                },
                                child: _open ? Text("Logout") : null,
                              ),
                              SizedBox(
                                height: AppSizes.sm,
                              ),
                              Divider(),
                              SizedBox(height: AppSizes.lg),
                            ],
                          ),
                        );
                      },
                    ),
                    ...items,
                  ],
                  title: Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: Center(
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
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                softWrap: false,
                              ),
                            ),
                          ),
                          isLargeScreen(context) && _open
                              ? Text("Ifri Base de Données Machines")
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  controller: controller,
                  style: SideMenuStyle(
                    displayMode: displayMode.value,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    hoverColor: Theme.of(context).colorScheme.primaryContainer,
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    selectedIconColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    selectedTitleTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    unselectedIconColor:
                        Theme.of(context).colorScheme.onSurface.withAlpha(150),
                    unselectedTitleTextStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    ),
                    itemBorderRadius: BorderRadius.circular(50),
                    itemOuterPadding: EdgeInsets.all(AppSizes.sm / 2),
                    showTooltip: true,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                  ),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
