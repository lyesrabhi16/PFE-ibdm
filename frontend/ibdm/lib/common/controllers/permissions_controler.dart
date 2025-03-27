import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class PermissionsController extends GetxController {
  PermissionsController() {
    loadPermissions();
  }

  bool permissions_loading = false;
  Rx<bool> ready = false.obs;
  bool? hasViewSiroperiePagePerm;
  bool? hasViewUsersPagePerm;
  bool? hasViewFiltrationPagePerm;
  bool? hasViewSettingsPagePerm;
  bool? hasViewEmailScheduleSettingsPerm;
  bool? hasViewEmailAlertsPerm;
  bool? hasViewEmailsSentPerm;
  bool? hasViewUtilitePagePerm;

  Future<void> loadPermissions() async {
    if (permissions_loading) {
      return;
    }
    permissions_loading = true;
    ready.value = false;
    int permissionsLoadedCount = 0;
    int maxPermissionsLoadedCount = 8;
    _done() {
      permissionsLoadedCount++;
      logger.e("loaded ${permissionsLoadedCount} permissions");

      if (permissionsLoadedCount == maxPermissionsLoadedCount) {
        permissionsLoadedCount = 0;
        ready.value = true;
      }
      permissions_loading = false;
    }

    try {
      logger.e("await permissions");
      await Future.wait([
        _hasPermRequest(Permissions.viewSiroperiePage).then(
          (value) {
            hasViewSiroperiePagePerm = value;
            _done();
          },
        ),
        _hasPermRequest(Permissions.viewUsersPage).then((value) {
          hasViewUsersPagePerm = value;
          _done();
        }),
        _hasPermRequest(Permissions.viewFiltrationPage).then((value) {
          hasViewFiltrationPagePerm = value;
          _done();
        }),
        _hasPermRequest(Permissions.viewSettingsPage).then((value) {
          hasViewSettingsPagePerm = value;
          _done();
        }),
        _hasPermRequest(Permissions.viewEmailSchedules).then((value) {
          hasViewEmailScheduleSettingsPerm = value;
          _done();
        }),
        _hasPermRequest(Permissions.viewEmailAlerts).then((value) {
          hasViewEmailAlertsPerm = value;
          _done();
        }),
        _hasPermRequest(Permissions.viewEmailsSent).then((value) {
          hasViewEmailsSentPerm = value;
          _done();
        }),
        _hasPermRequest(Permissions.viewUtilitePage).then((value) {
          hasViewUtilitePagePerm = value;
          _done();
        }),
      ]);
    } catch (e) {
      logger.e("Failed to get permissions: $e");
    }
  }

  void resetPermissions() {
    logger.e("reset permissions");
    hasViewSiroperiePagePerm = null;
    hasViewUsersPagePerm = null;
    hasViewFiltrationPagePerm = null;
    hasViewSettingsPagePerm = null;
    hasViewEmailScheduleSettingsPerm = null;
    hasViewEmailAlertsPerm = null;
    hasViewEmailsSentPerm = null;
    hasViewUtilitePagePerm = null;
    ready.value = false;
    logger.e("end reset permissions");
  }

  Future<bool> _hasPermRequest(String perm) async {
    try {
      final api = await ApiClientInstance.getApiClient();
      final res = await api.hasPerm(codename: perm);
      printMessage("Has perm $perm: ${res.hasPerm}");
      return res.hasPerm;
    } catch (e) {
      logger.e("Failed to get permission $perm: $e");
      return false;
    }
  }

  bool hasPerm(String permission) {
    try {
      if (ready.value == false) {
        throw ("Permissions not ready");
      }

      switch (permission) {
        case Permissions.viewSiroperiePage:
          return hasViewSiroperiePagePerm!;
        case Permissions.viewUsersPage:
          return hasViewUsersPagePerm!;
        case Permissions.viewFiltrationPage:
          return hasViewFiltrationPagePerm!;
        case Permissions.viewSettingsPage:
          return hasViewSettingsPagePerm!;
        case Permissions.viewEmailSchedules:
          return hasViewEmailScheduleSettingsPerm!;
        case Permissions.viewEmailAlerts:
          return hasViewEmailAlertsPerm!;
        case Permissions.viewEmailsSent:
          return hasViewEmailsSentPerm!;
        case Permissions.viewUtilitePage:
          return hasViewUtilitePagePerm!;
        default:
          throw ("Permission not found");
      }
    } catch (e) {
      logger.e("Failed to get permission: $e");
      return false;
    }
  }
}
