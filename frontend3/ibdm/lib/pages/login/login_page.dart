import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Pour vérifier la plateforme
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/pages/login/wide_login_page.dart';
import 'package:ibdm/pages/login/small_login_page.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = !kIsWeb;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150.0,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to your app',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: isSmallScreen(context)
            ? SmallLoginPage()
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text('IBDM'),
                    snap: true,
                    centerTitle: true,
                    floating: true,
                    pinned: true,
                    leading: ThemeModeSwitchButton(),
                    actions: [
                      LanguageSwitchButton(),
                      SizedBox(width: AppSizes.sm),
                    ],
                  ),
                ],
                body: SizedBox(
                  width: context.width,
                  height: context.height,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: WideLoginPage(),
                  ),
                ),
              ),
      ),
    );
  }
}
