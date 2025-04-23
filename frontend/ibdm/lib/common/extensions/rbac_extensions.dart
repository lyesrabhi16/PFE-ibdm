import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controller.dart';
import 'package:ibdm/utils/constants/destinations.dart';

extension RBACWidgetExtension on Widget {
  Widget? withPermission(String permission) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissionsController.hasPerm(permission) ? this : null;
  }

  Widget? withAnyPermissionOf(List<String> permissions) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissions
            .any((permission) => permissionsController.hasPerm(permission))
        ? this
        : null;
  }
}

extension RBACGetPageExtension on GetPage {
  GetPage? withPermission(String permission) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissionsController.hasPerm(permission) ? this : null;
  }

  GetPage? withAnyPermissionOf(List<String> permissions) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissions
            .any((permission) => permissionsController.hasPerm(permission))
        ? this
        : null;
  }
}

extension RbacDestinationExtensions on Destination {
  Destination? withPermission(String permission) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissionsController.hasPerm(permission) ? this : null;
  }

  Destination? withAnyPermissionOf(List<String> permissions) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissions
            .any((permission) => permissionsController.hasPerm(permission))
        ? this
        : null;
  }
}
