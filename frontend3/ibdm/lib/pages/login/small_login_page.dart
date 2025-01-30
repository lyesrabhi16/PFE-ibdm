import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/pages/login/actions.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class SmallLoginPage extends StatelessWidget {
  SmallLoginPage({super.key});

  final Rx<CheckboxState> _rememberMe = CheckboxState.unchecked.obs;
  final Rx<FutureState> _loginProgress = FutureState.loading.obs;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: AppSizes.xl * 5,
                      ),
                      SizedBox(height: AppSizes.md),
                      Text(
                        strings.value.login,
                        textAlign: TextAlign.center,
                        style: TextStyle().copyWith(
                            fontSize: AppSizes.lg, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSizes.md),
                      DividerWithText(
                        text: strings.value.loginToContinue,
                      ),
                      SizedBox(height: AppSizes.lg),
                      TextFormField(
                        controller: _emailController,
                        validator: FormBuilderValidators.email(
                          errorText: strings.value.invalidEmail,
                        ),
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary),
                          filled: true,
                          labelText: strings.value.email,
                          hintText: strings.value.enterYourEmail,
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: _passwordController,
                        validator: FormBuilderValidators.required(
                          errorText: strings.value.requiredPassword,
                        ),
                        autofillHints: [AutofillHints.password],
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,
                              color: Theme.of(context).colorScheme.primary),
                          filled: false,
                          labelText: strings.value.password,
                          hintText: strings.value.enterYourPassword,
                        ),
                      ),
                      SizedBox(height: AppSizes.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Obx(
                            () => Checkbox(
                              value: _rememberMe.value == CheckboxState.checked,
                              tristate: false,
                              onChanged: (value) {
                                _rememberMe.value = value!
                                    ? CheckboxState.checked
                                    : CheckboxState.unchecked;
                              },
                              semanticLabel: strings.value.rememberMe,
                            ),
                          ),
                          Text(strings.value.rememberMe),
                        ],
                      ),
                      SizedBox(height: AppSizes.lg),
                      FilledButton(
                        child: Text(strings.value.login),
                        onPressed: () => LoginActions.login(
                          context: context,
                          loginFormKey: _loginFormKey,
                          loginProgress: _loginProgress,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
