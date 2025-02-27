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
  bool? hasViewSiroperiePage;
  bool? hasViewUsersPage;

  Future<void> loadPermissions() async {
    try {
      ready.value = false;

      final api = await ApiClientInstance.getApiClient();
      final perm_siroperie = await api
          .hasPerm(codename: Permissions.viewSiroperiePage)
          .catchError((e) {
        return HasPermResponse.fromJson((e as DioException).response?.data);
      });
      hasViewSiroperiePage = perm_siroperie.hasPerm;
      final perm_users = await api
          .hasPerm(codename: Permissions.viewUsersPage)
          .catchError((e) {
        return HasPermResponse.fromJson((e as DioException).response?.data);
      });
      hasViewUsersPage = perm_users.hasPerm;

      ready.value = true;
    } catch (e) {
      logger.e("Failed to get permissions: $e");
    }
  }

  bool hasPerm(String permission) {
    try {
      if (ready.value == false) {
        throw ("Permissions not ready");
      }

      switch (permission) {
        case Permissions.viewSiroperiePage:
          return hasViewSiroperiePage!;
        case Permissions.viewUsersPage:
          return hasViewUsersPage!;
        default:
          throw ("Permission not found");
      }
    } catch (e) {
      logger.e("Failed to get permission: $e");
      return false;
    }
  }
}
