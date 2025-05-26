import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/permissions_controller.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class UserController extends GetxController {
  final Rx<User?> _user = (null as User?).obs;

  User? get user => _user.value;
  set user(User? value) => _user.value = value;

  List<Role> roles = <Role>[];
  Future<List<Role>> getRoles(BuildContext context) async {
    try {
      if (roles.isEmpty) {
        await _loadRoles(context);
      }
      return roles;
    } catch (e) {
      logger.e("Error loading roles: $e");
      return [];
    }
  }

  Future<void> _loadRoles(BuildContext context) async {
    logger.e("Loading roles...");
    final res = await (await ApiClientInstance.getApiClient()).getRoles(
      enablePagination: false,
    );
    logger.e("Roles: ${res.data.length}");
    roles = res.data;
  }

  bool get isAuthenticated => () {
        printMessage(
            "Checking if user is authenticated: ${user != null} ${user?.email}");
        return user != null;
      }();

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void logoutUser() {
    LocalStorage.removeUser();
    _user.value = null;
    PermissionsController permissionsController =
        Get.find<PermissionsController>();
    permissionsController.resetPermissions();
    ApiClientInstance.getApiClient().then((apiClient) {
      apiClient.logout();
    }).catchError((e) {
      logger.e("Error logging out user: $e");
    });
  }

  void setUser(User user) {
    LocalStorage.setUser(user);
    _user.value = user;
  }

  void fetchUser() async {
    User? user = await LocalStorage.getUser();
    this.user = user;
    fetchUserFromApi();
  }

  void fetchUserFromApi({Function(dynamic e)? onFail}) async {
    // fetch user from api
    final apiClient = await ApiClientInstance.getApiClient();
    try {
      final response = await apiClient.getCurrentUserInfo();
      setUser(response);
    } catch (e) {
      logoutUser();
      Get.offAllNamed(Routes.login);
      onFail?.call(e);
    }
  }
}
