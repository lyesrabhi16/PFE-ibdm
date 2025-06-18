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

  RxBool isReady = false.obs;

  @override
  void onInit() async {
    isReady.value = false;
    await fetchUser();
    logger.d("UserController initialized with user: ${_user.value}");
    super.onInit();
    isReady.value = true;
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

  void setUser(User user, {bool rememberMe = true}) {
    if (rememberMe) {
      LocalStorage.setUser(user);
    }
    _user.value = user;
  }

  Future<void> fetchUser() async {
    User? user = await LocalStorage.getUser();
    _user.value = user;
    fetchUserFromApi();
  }

  Future<void> fetchUserFromApi({Function(dynamic e)? onFail}) async {
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
