import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class PermissionsController extends GetxController {
  PermissionsController() {
    loadPermissions();
  }

  Rx<bool> ready = false.obs;
  bool? hasViewSiroperiePagePerm;
  bool? hasViewUsersPagePerm;
  bool? hasViewFiltrationPagePerm;
  bool? hasViewSettingsPagePerm;

  Future<void> loadPermissions() async {
    ready.value = false;

    hasViewSiroperiePagePerm =
        await _hasPermRequest(Permissions.viewSiroperiePage);
    hasViewUsersPagePerm = await _hasPermRequest(Permissions.viewUsersPage);
    hasViewFiltrationPagePerm =
        await _hasPermRequest(Permissions.viewFiltrationPage);
    hasViewSettingsPagePerm =
        await _hasPermRequest(Permissions.viewSettingsPage);
    logger.e("HasViewSettingsPagePerm: $hasViewSettingsPagePerm");
    ready.value = true;
  }

  void resetPermissions() {
    ready.value = false;
    hasViewSiroperiePagePerm = null;
    hasViewUsersPagePerm = null;
    hasViewFiltrationPagePerm = null;
    hasViewSettingsPagePerm = null;
  }

  Future<bool> _hasPermRequest(String perm) async {
    try {
      final api = await ApiClientInstance.getApiClient();
      final res = await api.hasPerm(codename: perm).catchError((e) {
        return HasPermResponse.fromJson((e as DioException).response?.data);
      });
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
        default:
          throw ("Permission not found");
      }
    } catch (e) {
      logger.e("Failed to get permission: $e");
      return false;
    }
  }
}
