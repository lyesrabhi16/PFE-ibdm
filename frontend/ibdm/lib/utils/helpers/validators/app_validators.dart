import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class AppValidators {
  const AppValidators._();

  static String? phoneNumberValidator(String v) {
    final strings = getTranslations(Get.context!);
    return FormBuilderValidators.compose([
      FormBuilderValidators.conditional(
        (String? v) => v != null ? v.isNotEmpty : false,
        FormBuilderValidators.phoneNumber(
          errorText: strings.invalidField(strings.phoneNumber),
        ),
      ),
    ])(v);
  }

  static String? roleSelectionValidator(String? v) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
    ])(v);
  }

  static String? perPageValidator(String? value, Rx<bool> expandPerPage) {
    final String? error = IntegerValidator().validate(value);
    if (error != null) {
      expandPerPage.value = true;
      return error;
    } else {
      expandPerPage.value = false;
    }
    return null;
  }

  static String? monitoredValueValidator(String? v) {
    final strings = getTranslations(Get.context!);
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
          errorText: strings.valueIsRequired(strings.monitoredValue)),
    ])(v);
  }

  static String? superiorSelectionValidator(
      String? userId, String? superiorid, List<User> superiorOptions) {
    UserController userController = Get.find<UserController>();
    final strings = getTranslations(Get.context!);
    if (userController.user?.userId.toString() == superiorid &&
        userId == userController.user?.userId.toString()) {
      return strings.cannotBeASuperiorToYourself;
    }

    if (userId != null && superiorid != null && userId == superiorid) {
      return strings.cannotBeASuperiorForHimself;
    }

    if (userController.user?.role == "ADMIN_SYSTEM") {
      return null;
    }
    return FormBuilderValidators.compose([
      FormBuilderValidators.conditional(
          (String? id) => id != null ? id.isNotEmpty : false,
          FormBuilderValidators.containsElement(
            superiorOptions.map((u) => "${u.userId}").toList(),
          ))
    ])(superiorid);
  }

  static String? customPasswordValidator(
    String v, {
    bool optional = false,
  }) {
    final strings = getTranslations(Get.context!);
    return optional && v.isEmpty
        ? null
        : FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: strings.valueIsRequired(strings.password),
            ),
            FormBuilderValidators.minLength(
              8,
              errorText: strings.minLength(8),
            ),
            FormBuilderValidators.maxLength(
              255,
              errorText: strings.maxLength(255),
            ),
            FormBuilderValidators.hasLowercaseChars(
              atLeast: 1,
              errorText: strings.hasLowercaseChars(1),
            ),
            FormBuilderValidators.hasUppercaseChars(
              atLeast: 1,
              errorText: strings.hasUppercaseChars(1),
            ),
            FormBuilderValidators.hasNumericChars(
              atLeast: 1,
              errorText: strings.hasNumericChars(1),
            ),
            FormBuilderValidators.hasSpecialChars(
              atLeast: 1,
              errorText: strings.hasSpecialChars(1),
            ),
          ])(v);
  }
}
