import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class RoutePermissions {
  List<String>? requiredPermissions;
  List<String>? anyOfPermissions;

  final PermissionsController permissionsController =
      Get.find<PermissionsController>();

  RoutePermissions({this.requiredPermissions, this.anyOfPermissions});

  bool checkRequiredPermissions() {
    if (permissionsController.ready.value == false) {
      logger.e("permissions not ready in checkRequiredPermissions");
      throw ("permissions not ready in checkRequiredPermissions");
    }
    if (requiredPermissions != null) {
      if (!requiredPermissions!
          .every((permission) => permissionsController.hasPerm(permission))) {
        logger.e("lacks all/some requiredPermissions");
        return false;
      }
    }
    return true;
  }

  bool checkAnyOfPermissions() {
    if (permissionsController.ready.value == false) {
      logger.e("permissions not ready in checkAnyOfPermissions");
      throw ("permissions not ready in checkAnyOfPermissions");
    }
    if (anyOfPermissions != null) {
      if (!anyOfPermissions!
          .any((permission) => permissionsController.hasPerm(permission))) {
        logger.e("doesn't have any of anyOfPermissions");
        return false;
      }
    }
    return true;
  }

  bool checkPermissions() {
    return checkRequiredPermissions() && checkAnyOfPermissions();
  }
}
