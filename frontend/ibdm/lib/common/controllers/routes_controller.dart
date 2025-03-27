import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class RoutesController extends GetxController {
  RxList<GetPage> _routes = <GetPage>[].obs;
  get routes {
    _routes.clear();
    _routes.addAll(Routes.router);
    printMessage("RoutesController: $_routes");
    return _routes;
  }
}
