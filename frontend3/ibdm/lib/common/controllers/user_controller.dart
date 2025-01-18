import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api/api_client/export.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';

class UserController extends GetxController {
  final Rx<User?> _user = (null as User?).obs;

  User? get user => _user.value;
  set user(User? value) => _user.value = value;

  bool get isAuthenticated => () {
        print(
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
  }

  void setUser(User user) {
    LocalStorage.setUser(user);
    _user.value = user;
  }

  void fetchUser() async {
    // fetch user from api
    User? user = await LocalStorage.getUser();
    if (user == null) {
      fetchUserFromApi();
      return;
    }
    this.user = user;
  }

  void fetchUserFromApi({Function(dynamic e)? onFail}) async {
    // fetch user from api
    IbdmApiClient apiClient = await ApiClientInstance.getApiClient();
    try {
      GetUserResponse response = await apiClient.getCurrentUser();
      setUser(response.user);
    } catch (e) {
      onFail?.call(e);
    }
  }
}
