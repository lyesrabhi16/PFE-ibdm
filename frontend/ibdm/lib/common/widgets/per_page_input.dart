import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/validators/app_validators.dart';

class PerPageInput extends StatelessWidget {
  final TextEditingController _perPageController;
  final RxBool _expandPerPage;
  final Function? load;
  int perPage;
  PerPageInput({
    super.key,
    required RxBool expandPerPage,
    required TextEditingController perPageController,
    this.load,
    this.perPage = 10,
  })  : _expandPerPage = expandPerPage,
        _perPageController = perPageController;

  final GlobalKey<FormState> perPageFormKey = GlobalKey<FormState>();

  void _executeChangePerPageIfPossible(GlobalKey<FormState> perPageFormKey) {
    if (perPageFormKey.currentState != null &&
        perPageFormKey.currentState!.validate()) {
      load?.call();
    }
  }

  void _changePerPage(String value) {
    if (value.isEmpty) {
      _perPageController.text = "$perPage";
    }
    int? newPerPage = int.tryParse(value);

    if (newPerPage != null) {
      perPage = newPerPage;
      LocalStorage.setPerPage(newPerPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    return Form(
      key: perPageFormKey,
      onChanged: () {},
      child: TextFormField(
        validator: (value) => AppValidators.perPageValidator(
          value,
          _expandPerPage,
        ),
        controller: _perPageController,
        onTapOutside: (_) => _executeChangePerPageIfPossible(
            perPageFormKey), // execute change per page if possible
        onEditingComplete: () => _executeChangePerPageIfPossible(
            perPageFormKey), // execute change per page if possible
        onChanged: (value) => _changePerPage(value),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: strings.value.perPage,
          hintText: "10",
        ),
      ),
    );
  }
}
