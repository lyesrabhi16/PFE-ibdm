import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/services/api/api_client/export.dart';

class AppValidators {
  const AppValidators._();

  static String? phoneNumberValidator(String v) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.conditional(
        (String? v) => v != null ? v.isNotEmpty : false,
        FormBuilderValidators.phoneNumber(),
      ),
    ])(v);
  }

  static String? roleSelectionValidator(String? v) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.containsElement(
          Role.values.map((r) => r.name).toList(),
          errorText: "Invalid Role")
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

  static String? superiorSelectionValidator(
      String? id, List<User> superiorOptions) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.conditional(
          (String? id) => id != null ? id.isNotEmpty : false,
          FormBuilderValidators.containsElement(
            superiorOptions.map((u) => u.id).toList(),
          ))
    ])(id);
  }

  static String? customPasswordValidator(String v) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(8),
      FormBuilderValidators.maxLength(255),
      FormBuilderValidators.hasLowercaseChars(atLeast: 1),
      FormBuilderValidators.hasUppercaseChars(atLeast: 1),
      FormBuilderValidators.hasNumericChars(atLeast: 1),
      FormBuilderValidators.hasSpecialChars(atLeast: 1),
    ])(v);
  }
}
