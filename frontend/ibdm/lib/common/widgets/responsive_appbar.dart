import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:toastification/toastification.dart';

class ResponsiveAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String userName;
  final String userImage;
  final VoidCallback onLogout;

  const ResponsiveAppBar({
    super.key,
    required this.userName,
    required this.userImage,
    required this.onLogout,
  });

  @override
  State<ResponsiveAppBar> createState() => _ResponsiveAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ResponsiveAppBarState extends State<ResponsiveAppBar> {
  final _popoverController = ShadPopoverController();
  final RxBool _logoutHover = false.obs;
  final RxBool _profileHover = false.obs;
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    final userController = Get.find<UserController>();
    final strings = getTranslations(context).obs;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      title: Row(
        children: [
          Image.asset(
            "assets/images/ifruit_logo.png",
            height: 30,
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /* Image.asset(
                "assets/images/logo.png",
                height: 30,
              ),
              const SizedBox(width: 8),
              const Text(
                'IBDM',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ), */
            ],
          ),
          const Spacer(),
        ],
      ),
      actions: [
        Row(
          children: [
            if (!isSmallScreen)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  userController.user != null
                      ? getUserName(userController.user!)
                      : "How did you get here?",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ShadPopover(
              controller: _popoverController,
              decoration: ShadDecoration(
                border: ShadBorder(
                  radius: BorderRadius.circular(AppSizes.borderRadius),
                ),
              ),
              padding: EdgeInsets.zero,
              popover: (context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: AppSizes.xl * 6,
                  ),
                  child: Obx(() {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        MouseRegion(
                          onEnter: (event) => _profileHover.value = true,
                          onExit: (event) => _profileHover.value = false,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _profileHover.value
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.borderRadius),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.person, size: 18),
                              iconColor: !_profileHover.value
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                              title: Text(
                                strings.value.profile,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: !_profileHover.value
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                              ),
                              onTap: () {
                                Get.toNamed(Routes.profile);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        MouseRegion(
                          onEnter: (event) => _logoutHover.value = true,
                          onExit: (event) => _logoutHover.value = false,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _logoutHover.value ? errorColor : null,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.borderRadius),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.logout, size: 18),
                              iconColor: !_logoutHover.value
                                  ? errorColor
                                  : Theme.of(context).colorScheme.onSurface,
                              title: Text(
                                strings.value.logout,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: !_logoutHover.value
                                          ? errorColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                              ),
                              onTap: () {
                                widget.onLogout();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                );
              },
              child: IconButton(
                onPressed: () {
                  _popoverController.toggle();
                },
                icon: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (widget.userImage.isNotEmpty)
                      ? NetworkImage(widget.userImage)
                      : null,
                  child: (widget.userImage.isNotEmpty)
                      ? null
                      : ShadAvatar(
                          LucideIcons.circleUserRound,
                          fit: BoxFit.cover,
                          backgroundColor: userController.user != null
                              ? AppColors.getRoleColorWithRoleValue(
                                  userController.user!.role)
                              : null,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
