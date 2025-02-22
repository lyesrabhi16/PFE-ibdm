import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/side_menu_state_controller.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/actions_row.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class SideMenuContainer extends StatelessWidget {
  const SideMenuContainer({super.key, required this.child});

  static final SideMenuController controller = SideMenuController();
  final Widget child;
  static void onItemTap(int index) {
    logger.d("index: $index");
  }

  static SideMenuStateController sideMenuStateController =
      Get.find<SideMenuStateController>();
  static bool _added = false;

  static bool get open => sideMenuStateController.isOpen;
  static set open(bool value) => sideMenuStateController.isOpen = value;

  static Rx<SideMenuDisplayMode> displayMode = SideMenuDisplayMode.compact.obs;

  @override
  Widget build(BuildContext context) {
    if (!_added) {
      controller.addListener(onItemTap);
      _added = true;
    }
    final strings = getTranslations(context).obs;

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
                  onDisplayModeChanged: (value) {
                    final isOpen = value == SideMenuDisplayMode.open;
                    if (isOpen != open) {
                      open = isOpen;
                    }
                  },
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
                                  open
                                      ? Icons.arrow_back_ios_rounded
                                      : Icons.arrow_forward_ios_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () {
                                  displayMode.value = open
                                      ? SideMenuDisplayMode.compact
                                      : SideMenuDisplayMode.open;
                                  open = !open;
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
                                child: open ? Text(strings.value.logout) : null,
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
                                strings.value.ibdm,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                softWrap: false,
                              ),
                            ),
                          ),
                          isLargeScreen(context) && open
                              ? Text(strings.value.ifri_bdd)
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
