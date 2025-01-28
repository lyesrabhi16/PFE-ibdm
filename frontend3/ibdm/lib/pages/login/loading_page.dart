import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';

class LoadingPage extends StatefulWidget {
  //const LoadingPage({Key? key}) : super(key: key);
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // Naviguer vers la page de connexion après 10 secondes
    Future.delayed(const Duration(seconds: 10), () {
      Get.offNamed(Routes.home); // Redirige vers LoginPage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: MediaQuery.of(context).size.height * 0.2,
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
}
