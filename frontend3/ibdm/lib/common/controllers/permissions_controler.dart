import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';

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

  Future<void> loadPermissions() async {
    if (permissions_loading) {
      return;
    }
    permissions_loading = true;
    ready.value = false;
    int permissionsLoadedCount = 0;
    int maxPermissionsLoadedCount = 4;
    _done() {
      permissionsLoadedCount++;
      logger.e("loaded ${permissionsLoadedCount} permissions");

      if (permissionsLoadedCount == maxPermissionsLoadedCount) {
        permissionsLoadedCount = 0;
        ready.value = true;
      }
      permissions_loading = false;
    }

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
    ]);
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
        final loadingPageController = Get.find<LoadingPageController>();
        if (loadingPageController.isLoading.value == false) {
          loadingPageController.isLoading.value = true;
        }
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
