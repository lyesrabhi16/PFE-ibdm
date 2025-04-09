import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class PermissionsController extends GetxController {
  bool permissions_loading = false;
  Rx<bool> ready = false.obs;
  List<String> perms = [];

  Future<void> loadPermissions() async {
    if (permissions_loading) {
      logger.e("REFUSED TO LOAD: loading permissions is already in progress");
      return;
    }
    permissions_loading = true;
    await Future.delayed(Duration(microseconds: 100), () {
      ready.value = false;
    });

    try {
      logger.e("await permissions");
      final api = await ApiClientInstance.getApiClient();
      final res = await api.getAllUserPerms();
      perms = res.perms;
      logger.e("permissions set");
      return Future.delayed(Duration(microseconds: 100), () {
        permissions_loading = false;
        ready.value = true;
        logger.e("permissions ready");
      });
    } catch (e) {
      perms = [];
      logger.e("Failed to get permissions: $e");
      return Future.delayed(Duration(microseconds: 100), () {
        permissions_loading = false;
        ready.value = true;
      });
    }
  }

  void resetPermissions() {
    logger.e("reset permissions");
    perms = [];
    ready.value = false;
    logger.e("end reset permissions");
  }

  bool hasPerm(String permission) {
    try {
      if (ready.value == false) {
        throw ("Permissions not ready");
      }

      if (perms.contains(permission)) {
        return true;
      }

      return false;
    } catch (e) {
      logger.e("Failed to get permission: $e");
      return false;
    }
  }
}
