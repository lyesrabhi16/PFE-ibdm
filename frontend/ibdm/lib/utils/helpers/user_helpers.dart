import 'package:get/get.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/helpers/localization.dart';

String getUserName(User user, {bool orEmail = true}) {
  final strings = getTranslations(Get.context!);
  if (user.username.isNotEmpty) {
    return user.username;
  } else if (user.firstName.isNotEmpty && user.lastName.isNotEmpty) {
    return '${user.firstName} ${user.lastName}';
  } else if (orEmail && user.email.isNotEmpty) {
    return user.email;
  } else {
    return strings.noUsername;
  }
}
