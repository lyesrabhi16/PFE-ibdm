import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/colors.dart';

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
            PopupMenuButton<String>(
              offset: const Offset(0, 40),
              onSelected: (String value) {
                if (value == 'Logout') {
                  Get.find<UserController>().logoutUser();
                  Get.offAllNamed(Routes.login);
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'Logout',
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        Rx<bool> isHovering = false.obs;
                        return MouseRegion(
                          onEnter: (_) => isHovering.value = true,
                          onHover: (_) => isHovering.value = true,
                          onExit: (_) => isHovering.value = false,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isHovering.value
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.logout, size: 18),
                              title: const Text(
                                'Logout',
                                style: TextStyle(fontSize: 12),
                              ),
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                              iconColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ];
              },
              child: CircleAvatar(
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
                        backgroundColor: AppColors.getRoleColorWithRoleValue(
                            userController.user!.role),
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
