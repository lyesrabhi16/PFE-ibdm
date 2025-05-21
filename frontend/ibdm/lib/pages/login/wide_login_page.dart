import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/pages/login/actions.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WideLoginPage extends StatelessWidget {
  final Rx<CheckboxState> _rememberMe = CheckboxState.unchecked.obs;
  final Rx<FutureState> _loginProgress = FutureState.idle.obs;
  final RxBool _showPassword = false.obs;
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController =
      TextEditingController();
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  WideLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 450,
            maxWidth: 450,
            minHeight: 600,
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    loginFormKey: _loginFormKey),
              ),
            ),
          ).paddingAll(AppSizes.md),
        ),
      ],
    ).paddingAll(AppSizes.sm);
  }
}

class LoginPageContent extends StatelessWidget {
  const LoginPageContent({
    super.key,
    required this.strings,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required RxBool showPassword,
    required Rx<CheckboxState> rememberMe,
    required Rx<FutureState> loginProgress,
    required GlobalKey<FormState> loginFormKey,
  })  : _emailController = emailController,
        _passwordController = passwordController,
        _showPassword = showPassword,
        _rememberMe = rememberMe,
        _loginProgress = loginProgress,
        _loginFormKey = loginFormKey;

  final Rx<AppLocalizations> strings;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final RxBool _showPassword;
  final Rx<CheckboxState> _rememberMe;
  final Rx<FutureState> _loginProgress;
  final GlobalKey<FormState> _loginFormKey;

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
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
            style: TextStyle()
                .copyWith(fontSize: AppSizes.lg, fontWeight: FontWeight.bold),
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
            keyboardType: TextInputType.emailAddress,
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
          Obx(() {
            return TextFormField(
              controller: _passwordController,
              validator: FormBuilderValidators.required(
                errorText: strings.value.requiredPassword,
              ),
              autofillHints: [AutofillHints.password],
              autocorrect: false,
              obscureText: !_showPassword.value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                    color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    _showPassword.value = !_showPassword.value;
                  },
                ),
                filled: false,
                labelText: strings.value.password,
                hintText: strings.value.enterYourPassword,
              ),
            );
          }),
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
          Obx(() {
            return FilledButton.icon(
              icon: _loginProgress.value != FutureState.loading
                  ? Icon(Icons.login)
                  : SizedBox(
                      width: AppSizes.md,
                      height: AppSizes.md,
                      child: CircularProgressIndicator.adaptive()),
              style: FilledButton.styleFrom(
                backgroundColor: Get.isDarkMode
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.all(AppSizes.md),
              ),
              onPressed: _loginProgress.value != FutureState.loading
                  ? () => LoginActions.login(
                        context: context,
                        loginFormKey: _loginFormKey,
                        loginProgress: _loginProgress,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        rememberMe: _rememberMe.value ==
                            CheckboxState.checked, // rememberMe
                      )
                  : null,
              label: Text(strings.value.login),
            );
          }),
        ],
      ),
    );
  }
}
