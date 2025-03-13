import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';

class RoutesController extends GetxController {
  RxList<GetPage> _routes = <GetPage>[].obs;
  get routes {
    _routes.clear();
    _routes.addAll(Routes.router);
    print("RoutesController: $_routes");
    return _routes;
  }
}
