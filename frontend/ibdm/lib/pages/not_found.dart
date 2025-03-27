import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:toastification/toastification.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    return Obx(() {
      return AppCustomContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: errorColor,
              ),
              SizedBox(height: 20),
              Text(
                '404',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: errorColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                strings.value.pageNotFound,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
