import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class NoPermissionsPage extends StatelessWidget {
  final UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;

    return Obx(() {
      final _child = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock,
              size: 100,
              color: errorColor,
            ),
            SizedBox(height: 20),
            Text(
              '403',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: errorColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              strings.value.youDontHavePermissionToAccessThisPage,
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
      return userController.isAuthenticated
          ? AppCustomContainer(
              child: _child,
            )
          : Scaffold(
              body: _child,
            );
    });
  }
}
