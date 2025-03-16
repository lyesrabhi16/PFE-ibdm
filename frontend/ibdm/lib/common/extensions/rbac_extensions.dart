import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/utils/constants/destinations.dart';

extension RBACWidgetExtension on Widget {}

extension RBACGetPageExtension on GetPage {}

extension RbacDestinationExtensions on Destination {
  Destination? withPermission(String permission) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    if (permissionsController.ready.value == false) {
      return null;
    }
    return permissionsController.hasPerm(permission) ? this : null;
  }
}
