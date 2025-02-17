import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/helpers/logger.dart';

extension RBACWidgetExtension on Widget {
  Widget withPermission(String permission) {
    return this;
  }
}

extension RBACGetPageExtension on GetPage {
  GetPage? allowRole(Role role) {
    UserController userController = Get.find();
    if (userController.user?.role == role) {
      logger.i("allowed ${userController.user?.role} from $role ");
      return this;
    }
    return null;
  }

  GetPage? allowRoles(List<Role> roles) {
    UserController userController = Get.find();
    if (roles.contains(userController.user?.role)) {
      logger.i("allowed ${userController.user?.role} from $roles ");
      return this;
    }
    return null;
  }

  GetPage? disallowRole(Role role) {
    UserController userController = Get.find();
    if (userController.user?.role == role) {
      logger.i("disallowed ${userController.user?.role} from $role ");
      return null;
    }
    return this;
  }

  GetPage? disallowRoles(List<Role> roles) {
    UserController userController = Get.find();
    if (!roles.contains(userController.user?.role)) {
      return this;
    }
    logger.i("disallowed ${userController.user?.role} from $roles ");
    return null;
  }

  GetPage? withPermission(String permission) {
    return this;
  }
}

extension RbacDestinationExtensions on Destination {
  Destination? allowRole(Role role) {
    UserController userController = Get.find();
    if (userController.user?.role == role) {
      logger.i("allowed ${userController.user?.role} from $role ");
      return this;
    }
    return null;
  }

  Destination? allowRoles(List<Role> roles) {
    UserController userController = Get.find();
    if (roles.contains(userController.user?.role)) {
      logger.i("allowed ${userController.user?.role} from $roles ");
      return this;
    }
    return null;
  }

  Destination? disallowRole(Role role) {
    UserController userController = Get.find();
    if (userController.user?.role == role) {
      logger.i("Disallowed ${userController.user?.role} from $role ");
      return null;
    }
    return this;
  }

  Destination? disallowRoles(List<Role> roles) {
    UserController userController = Get.find();
    if (!roles.contains(userController.user?.role)) {
      return this;
    }
    logger.i("Disallowed ${userController.user?.role} from $roles ");
    return null;
  }

  Destination? withPermission(String permission) {
    return this;
  }
}
