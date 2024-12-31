import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/login/wide_login_page.dart';
import 'package:ibdm/pages/login/small_login_page.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
