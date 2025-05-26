import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/pages/login/login_page.dart';
import 'package:ibdm/pages/login/wide_login_page.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/common_heplers.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class SmallLoginPage extends StatelessWidget {
  SmallLoginPage({super.key});

  final Rx<CheckboxState> _rememberMe = CheckboxState.unchecked.obs;
  final Rx<FutureState> _loginProgress = FutureState.idle.obs;
  final RxBool _showPassword = false.obs;
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ThemeModeSwitchButton(),
            Spacer(),
            LanguageSwitchButton(),
            IconButton(
              icon: Icon(Icons.card_membership),
              onPressed: () => downloadCertificate(context),
            ),
          ],
        ).paddingAll(AppSizes.sm),
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Padding(
                    padding: EdgeInsets.all(AppSizes.md),
                    child: LoginPageContent(
                        strings: strings,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        showPassword: _showPassword,
                        rememberMe: _rememberMe,
                        loginProgress: _loginProgress,
                        loginFormKey: _loginFormKey)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
