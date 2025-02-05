import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';

class RoutesController extends GetxController {
  final RxList<GetPage> _routes = <GetPage>[].obs;
  get routes {
    _routes.value = Routes.router;
    return _routes;
  }
}
