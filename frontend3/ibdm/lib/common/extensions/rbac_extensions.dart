import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/destinations.dart';
import 'package:ibdm/utils/helpers/logger.dart';

extension RBACWidgetExtension on Widget {}

extension RBACGetPageExtension on GetPage {}

extension RbacDestinationExtensions on Destination {
  Destination? withPermission(String permission) {
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    return permissionsController.hasPerm(permission) ? this : null;
  }
}
