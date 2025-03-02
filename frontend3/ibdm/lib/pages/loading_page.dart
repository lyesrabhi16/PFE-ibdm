import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    return Obx(
      () => Scaffold(
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
      ),
    );
  }
}
