import 'package:ibdm/services/api_django/api_client/export.dart';

String getUserName(User user) {
  if (user.username.isNotEmpty) {
    return user.username;
  } else if (user.firstName.isNotEmpty && user.lastName.isNotEmpty) {
    return '${user.firstName} ${user.lastName}';
  } else if (user.email.isNotEmpty) {
    return user.email;
  } else {
    return 'No Name Found For User';
  }
}
