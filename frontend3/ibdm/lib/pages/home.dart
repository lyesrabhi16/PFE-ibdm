import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Assurez-vous que le fichier existe
                height: 150.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to the app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final strings = getTranslations(context).obs;
    final localecontroller = Get.find<LocaleController>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(
              () => Center(
                child: Text(
                  strings.value.homePageWelcomeMessage,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SizedBox(height: AppSizes.sm),
            Text("Current Language: ${localecontroller.locale.value.languageCode}"),
            SizedBox(height: AppSizes.md),
            FilledButton(
              child: Obx(() => Text(strings.value.login)),
              onPressed: () {
                Get.toNamed(Routes.login);
              },
            ),
            SizedBox(height: AppSizes.md),
            FilledButton(
              child: Text(strings.value.logout),
              onPressed: () {
                Get.find<UserController>().logoutUser();
                Get.offAllNamed(Routes.login);
              },
            ),
            FilledButton(
              child: Text("protected"),
              onPressed: () {
                Get.toNamed("/protected");
              },
            ),
            SizedBox(height: AppSizes.md),
            FilledButton(
              child: Text(strings.value.logout),
              onPressed: () {
                Get.find<UserController>().logoutUser();
                Get.offAllNamed(Routes.login);
              },
            ),
            FilledButton(
              child: Text("protected"),
              onPressed: () {
                Get.toNamed("/protected");
              },
            ),
            SizedBox(height: AppSizes.md),
            const ActionsRow(),
          ],
        ),
      ),
    );
  }
}

class ActionsRow extends StatelessWidget {
  const ActionsRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ThemeModeSwitchButton(),
        LanguageSwitchButton(),
      ],
    );
  }
}
