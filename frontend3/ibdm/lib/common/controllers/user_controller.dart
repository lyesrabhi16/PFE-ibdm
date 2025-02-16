import 'dart:io';
import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api/api_client/export.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class UserController extends GetxController {
  final Rx<User?> _user = (null as User?).obs;

  User? get user => _user.value;
  set user(User? value) => _user.value = value;

  bool get isAuthenticated => user != null;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void logoutUser() {
    LocalStorage.removeUser();
    _user.value = null;
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
    if (user == null) {
      fetchUserFromApi();
      return;
    }
    this.user = user;
  }

  void fetchUserFromApi({Function(dynamic e)? onFail}) async {
    IbdmApiClient apiClient = await ApiClientInstance.getApiClient();
    try {
      GetUserResponse response = await apiClient.getCurrentUser();
      setUser(response.user);
    } catch (e) {
      onFail?.call(e);
    }
  }

  // Future<void> changeProfilePicture(File newImage) async {
  //    try {
  //      IbdmApiClient apiClient = await ApiClientInstance.getApiClient();

  //      String newAvatarUrl = await apiClient.uploadAvatar(newImage);

  //      if (_user.value != null) {
  //        User updatedUser = _user.value!.copyWith(avatarUrl: newAvatarUrl);
  //        setUser(updatedUser); // Mise à jour locale
  //      }
  //    } catch (e) {
  //      logger.e("Erreur lors du changement de photo : $e");
  //    }
  //  }
}
