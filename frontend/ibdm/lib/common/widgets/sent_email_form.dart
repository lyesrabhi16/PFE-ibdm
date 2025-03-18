import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/alert_email_form.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/email_schedule_form.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SentEmailForm extends StatelessWidget {
  SentEmailForm({
    super.key,
    this.showIdField = false,
    this.onValuesChanged,
    this.editable = true,
    this.sent,
    this.schedule,
    this.alert,
  });

  final bool editable;
  final SentEmail? sent;

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final Function({
    String? tempsEnvoi,
    String? receptionist,
    String? schedule,
    String? alert,
    bool? enabled,
  })? onValuesChanged;

  _valuesChanged() {
    if (!editable) return;
    print("tempenvoiController.text ${tempenvoiController.text}");
    print("receptionistController.text ${receptionistController.text}");
    print("scheduleController.text ${scheduleController.text}");
    print("alertController.text ${alertController.text}");
    print("enabled $enabled");
    onValuesChanged?.call(
      tempsEnvoi: tempenvoiController.text,
      receptionist: scheduleController.text,
      schedule: receptionistController.text,
      alert: alertController.text,
      enabled: enabled,
    );
  }

  final idController = TextEditingController(text: "Auto Generated");
  final tempenvoiController = TextEditingController();
  final scheduleController = TextEditingController(text: "1");
  final receptionistController =
      TextEditingController(text: "exemple@gmail.com");
  final alertController = TextEditingController(text: "7");

  bool enabled = true;

  late final strings = getTranslations(getContext).obs;
  final bool showIdField;
  final userController = Get.find<UserController>();
  IbdmApiClient? api;
  List<User> _users = [];
  List<String> _possibleMonitorValues = [];
  RxBool loaded = false.obs;

  final EmailSchedule? schedule;
  final AlertEmail? alert;

  final _formKey = GlobalKey<ShadFormState>();

  _loadUsers() async {
    try {
      final res = await api!.getUsers(
        enablePagination: false,
      );
      _users = res.data;
    } catch (e) {
      logger.e("Failed to load users : $e");
      Toasts.showErrorToast(
          context: getContext, message: "Failed to load users");
      Navigator.of(getContext).pop();
    }
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadUsers();
    await _loadPossibleMonitorValues();

    if (sent != null) {
      idController.text = sent!.id.toString();
      receptionistController.text = sent!.receptionist.toString();
      scheduleController.text = sent!.schedule.toString();
      alertController.text = sent!.alert.toString();
      //enabled = sent!.enabled;
      tempenvoiController.text = sent!.tempsEnvoi.toString();
    }

    loaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return Obx(() {
      if (!loaded.value) {
        load();
        return SizedBox(
          height: AppSizes.lg * 10,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return ShadForm(
          onChanged: _valuesChanged,
          child: Column(
            children: [
              SizedBox(height: AppSizes.lg),
              if (showIdField)
                ShadInputFormField(
                  enabled: editable,
                  controller: idController,
                  label: Text(strings.value.id),
                ),
              SizedBox(height: AppSizes.sm),
              Column(
                children: [
                  Text(strings.value.tempsEnvoi),
                  ShadDatePickerFormField(
                    enabled: editable,
                    label: Text(strings.value.nextRunTimeDate),
                    formatDate: (date) =>
                        "${date.day}/${date.month}/${date.year}",
                    initialValue: sent?.tempsEnvoi ?? DateTime.now(),
                  ),
                  ShadTimePicker(
                    enabled: editable,
                    initialValue: sent?.tempsEnvoi != null
                        ? ShadTimeOfDay.fromDateTime(sent!.tempsEnvoi)
                        : null,
                  )
                ],
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: receptionistController,
                label: Text(strings.value.receptionist),
                keyboardType: TextInputType.number,
                initialValue: "exemple@gmail.com",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              DividerWithText(
                  text: schedule != null
                      ? strings.value.schedule.toUpperCase()
                      : strings.value.alert.toUpperCase()),
              schedule != null
                  ? EmailScheduleForm(
                      schedule: schedule,
                      editable: false,
                      showIdField: true,
                    )
                  : AlertEmailForm(
                      formKey: _formKey,
                      alert: alert,
                      editable: false,
                      showIdField: true,
                    ),
              SizedBox(height: AppSizes.lg),
            ],
          ));
    });
  }

  _loadPossibleMonitorValues() async {
    // load possible monitor values
    try {
      final res = await api!.getPossibleMonitorValuesAlertEmails();
      _possibleMonitorValues = res.possibleValues;
    } catch (e) {
      logger.e("Failed to load users : $e");
      Toasts.showErrorToast(
          context: getContext,
          message: "Failed to load possible values for monitoring");
      Navigator.of(getContext).pop();
    }
  }
}
