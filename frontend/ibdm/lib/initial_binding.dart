import 'package:get/get.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/routes_controller.dart';
import 'package:ibdm/common/controllers/side_menu_state_controller.dart';
import 'package:ibdm/common/controllers/theme_mode_controller.dart';
import 'package:ibdm/common/controllers/user_controller.dart';

class InitialBinding implements Bindings {
  InitialBinding();

  @override
  void dependencies() {
    Get.put(LocaleController());
    Get.put(ThemeModeController());
    Get.put(UserController());
    Get.put(RoutesController());
    Get.put(SideMenuStateController(), permanent: true);
    Get.put(PermissionsController(), permanent: true);
  }
}
