import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/loading_page_controller.dart';
import 'package:ibdm/common/controllers/permissions_controler.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
  static bool inProgress = false;
}

class _LoadingPageState extends State<LoadingPage> {
  PermissionsController permissionsController =
      Get.find<PermissionsController>();

  LoadingPageController loadingPageController =
      Get.find<LoadingPageController>();

  UserController userController = Get.find<UserController>();

  bool _permissions_loaded = false;

  bool _roles_loaded = false;

  _loadFinished() {
    loadingPageController.isLoading.value = true;
    if (_permissions_loaded) {
      logger.e(
          "LOADING PROGRESS Permissions loaded: ${permissionsController.ready}");
    } else if (_roles_loaded) {
      logger.e("LOADING PROGRESS Roles loaded: ${userController.roles.length}");
    }

    if (_permissions_loaded && _roles_loaded) {
      Future.delayed(Duration(seconds: 1), () {
        loadingPageController.isLoading.value = false;
        LoadingPage.inProgress = false;
        logger
            .e("Loading page set to ${loadingPageController.isLoading.value}");
        logger.e("END LOADING");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    logger.e("BEGIN LOADING");

    _roles_loaded = false;
    userController.getRoles(context).then((value) {
      logger.e("Roles loaded: ${userController.roles.length}");

      _roles_loaded = true;
      _loadFinished();
    });

    if (!permissionsController.permissions_loading) {
      _permissions_loaded = false;
      permissionsController.loadPermissions().then((value) {
        logger.e("Permissions loaded: ${permissionsController.ready}");
        _permissions_loaded = true;
        _loadFinished();
      });
    }

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
                      strings.value.welcome,
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
