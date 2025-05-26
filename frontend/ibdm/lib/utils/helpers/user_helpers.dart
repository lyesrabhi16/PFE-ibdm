import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

String getUserName(User user, {bool orEmail = true}) {
  final strings = getTranslations(Get.context!);
  if (user.username.isNotEmpty) {
    return user.username;
  } else if (user.firstName.isNotEmpty && user.lastName.isNotEmpty) {
    return '${user.firstName} ${user.lastName}';
  } else if (orEmail && user.email.isNotEmpty) {
    return user.email;
  } else {
    return strings.noUsername;
  }
}

bool searchUsers(User element, String value) {
  return element.email.contains(value) ||
      element.firstName.contains(value) ||
      element.lastName.contains(value) ||
      element.username.contains(value);
}

bool searchRoles(Role role, String value) {
  return role.name.toLowerCase().contains(value.toLowerCase());
}

void loadSuperiorsOptions(
  BuildContext context, {
  required Rx<bool> loadedUserSuperiorOptions,
  required RxList<ShadOption<User>> ResultSuperiorOptions,
}) async {
  loadedUserSuperiorOptions.value = false;
  final strings = getTranslations(context).obs;
  final UserController userController = Get.find();
  final me =
      "${userController.user!.username.isEmpty ? userController.user!.email : userController.user!.username}(${strings.value.me})";
  List<ShadOption<User>> options = [
    ShadOption(
      value: userController.user!,
      child: Text(
        me,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.getRoleColorWithRoleValue(
                  userController.user!.role),
            ),
      ),
    ),
  ];

  try {
    logger.f("user in loadSuperiorsOptions: ${userController.user}");
    if (userController.user!.role == "ADMIN_SYSTEM") {
      logger.f("user is admin system");
      final api = await ApiClientInstance.getApiClient();
      final res = await api.getUsers(
        enablePagination: false,
      );
      logger.f("res: ${res.data.length}");
      for (User user in res.data) {
        logger.e("sup user id: ${user.userId}");
        user.userId != userController.user!.userId
            ? {
                options.add(
                  ShadOption(
                      value: user,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(getUserName(user, orEmail: true)),
                          SizedBox(width: AppSizes.md),
                          Text(
                            user.role,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.getRoleColorWithRoleValue(
                                      user.role),
                                ),
                          )
                        ],
                      )),
                ),
                logger.e("added user:${user.userId}"),
              }
            : logger.e(
                "skipping ${user.userId} because ${user.userId} ${userController.user!.userId} ${user.userId != userController.user!.userId}");
      }
      ResultSuperiorOptions.value = options;
      logger.e("superior options in func: $options ${res.data}");
      loadedUserSuperiorOptions.value = true;
      return;
    }
    traverseSubordinatesTree(User user, Function(User user) onUserFound) async {
      if (user.subordinates.isNotEmpty) {
        for (var user in user.subordinates) {
          final subUser = await (await ApiClientInstance.getApiClient())
              .getUser(id: user.userId);
          onUserFound(subUser);
          traverseSubordinatesTree(subUser, onUserFound);
        }
      }
    }

    await traverseSubordinatesTree(
      userController.user!,
      (user) => user.userId != userController.user!.userId
          ? options.add(
              ShadOption(
                  value: user,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(getUserName(user, orEmail: true)),
                      SizedBox(width: AppSizes.md),
                      Text(
                        user.role,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.getRoleColorWithRoleValue(
                                  user.role),
                            ),
                      )
                    ],
                  )),
            )
          : {},
    );

    ResultSuperiorOptions.value = options;
    loadedUserSuperiorOptions.value = true;
    return;
  } catch (e) {
    logger.e("failed to get users: $e");
    if (Get.context != null && Get.context!.mounted) {
      Toasts.showErrorToastNotification(
          context: Get.context!,
          message: strings.value.failedToGetUsersMessage,
          title: strings.value.errorFailedToGetUsers);
    }
    ResultSuperiorOptions.value = [];
    loadedUserSuperiorOptions.value = true;
    return;
  }
}
