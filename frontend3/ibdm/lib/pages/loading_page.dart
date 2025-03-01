import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key});

  PermissionsController permissionsController =
      Get.find<PermissionsController>();

  LoadingPageController loadingPageController =
      Get.find<LoadingPageController>();
  UserController userController = Get.find<UserController>();

  bool _permissions_loaded = false;
  bool _roles_loaded = false;

  _loadFinished() {
    if (_permissions_loaded && _roles_loaded) {
      Future.delayed(Duration(seconds: 1), () {
        loadingPageController.isLoading.value = false;
        logger
            .e("Loading page set to ${loadingPageController.isLoading.value}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;

    userController.getRoles(context).then((value) {
      logger.e("Roles loaded: ${userController.roles.length}");
      
      _roles_loaded = true;
      _loadFinished();
    });
    permissionsController.loadPermissions().then((value) {
      logger.e("Permissions loaded: ${permissionsController.ready}");
      _permissions_loaded = true;
      _loadFinished();
    });

    return Obx(
      () {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150.0,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      strings.value.homePageWelcomeMessage,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/images/ifruit.png',
                  height: 50.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
