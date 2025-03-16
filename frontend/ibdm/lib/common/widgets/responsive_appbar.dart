import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/sizes.dart';
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
  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    final userController = Get.find<UserController>();

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
              Image.asset(
                "assets/images/logo.png",
                height: 30,
              ),
              const SizedBox(width: 8),
              const Text(
                'IBDM',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
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
                  widget.userName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ShadPopover(
              controller: _popoverController,
              decoration: ShadDecoration(
                border: ShadBorder(
                  radius: BorderRadius.circular(AppSizes.sm),
                ),
              ),
              padding: EdgeInsets.zero,
              popover: (context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: AppSizes.xl * 5,
                  ),
                  child: Obx(() {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        MouseRegion(
                          onEnter: (event) => _logoutHover.value = true,
                          onExit: (event) => _logoutHover.value = false,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _logoutHover.value ? errorColor : null,
                              borderRadius: BorderRadius.circular(AppSizes.sm),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.logout, size: 18),
                              iconColor: !_logoutHover.value
                                  ? errorColor
                                  : Theme.of(context).colorScheme.onSurface,
                              title: Text(
                                'Logout',
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
