import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AlertEmailForm extends StatelessWidget {
  AlertEmailForm({
    super.key,
    this.showIdField = false,
    this.onValuesChanged,
    this.editable = true,
    this.alert,
  });

  final bool editable;
  final AlertEmail? alert;

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final Function({
    String? monitoredValue,
    String? dangerPoint,
    String? warningPoint,
    String? dangerAlertInterval,
    String? warningAlertInterval,
    List<Role>? roles,
    List<User>? users,
    String? customMessage,
    bool? enabled,
  })? onValuesChanged;

  _valuesChanged() {
    if (!editable) return;
    printMessage(
        "monitoredValueController.text ${monitoredValueController.text}");
    printMessage(
        "dangerAlertIntervalController.text ${dangerAlertIntervalController.text}");
    printMessage("dangerPointController.text ${dangerPointController.text}");
    printMessage(
        "warningAlertIntervalController.text ${warningAlertIntervalController.text}");
    printMessage("warningPointController.text ${warningPointController.text}");
    printMessage(
        "customMessageController.text ${customMessageController.text}");
    printMessage("sendToRoles ${sendToRoles.map((e) => e.name).join(', ')}");
    printMessage("sendToUsers ${sendToUsers.map((e) => e.email).join(', ')}");
    printMessage("enabled $enabled");
    onValuesChanged?.call(
      monitoredValue: monitoredValueController.text,
      dangerPoint: dangerPointController.text,
      warningPoint: warningPointController.text,
      dangerAlertInterval: dangerAlertIntervalController.text,
      warningAlertInterval: warningAlertIntervalController.text,
      roles: sendToRoles.toList(),
      users: sendToUsers.toList(),
      customMessage: customMessageController.text,
      enabled: enabled,
    );
  }

  final idController = TextEditingController(text: "Auto Generated");
  final monitoredValueController = TextEditingController();
  final dangerPointController = TextEditingController(text: "1000");
  final warningPointController = TextEditingController(text: "2500");
  final dangerAlertIntervalController = TextEditingController(text: "1");
  final warningAlertIntervalController = TextEditingController(text: "7");
  final customMessageController = TextEditingController(text: "");
  final sendToRoles = <Role>[];
  final sendToUsers = <User>[];

  bool enabled = true;

  late final strings = getTranslations(getContext).obs;
  final bool showIdField;
  final userController = Get.find<UserController>();
  IbdmApiClient? api;
  List<User> _users = [];
  List<String> _possibleMonitorValues = [];
  RxBool loaded = false.obs;

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

    if (alert != null) {
      idController.text = alert!.id.toString();
      customMessageController.text = alert!.customAlertMessage ?? "";
      dangerAlertIntervalController.text =
          alert!.dangerReminderInterval.toString();
      dangerPointController.text = alert!.dangerPoint.toString();
      warningAlertIntervalController.text =
          alert!.warningReminderInterval.toString();
      warningPointController.text = alert!.warningPoint.toString();
      enabled = alert!.enabled!;
      monitoredValueController.text = alert!.monitoredValue.toString();
      sendToRoles.addAll(
        userController.roles
            .where((role) => alert!.sendToRoles.contains(role.roleId)),
      );
      sendToUsers.addAll(
        _users.where((user) => alert!.sendToUsers.contains(user.email)),
      );
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
                  label: Text("id"),
                ),
              SizedBox(height: AppSizes.sm),
              Container(
                constraints: BoxConstraints(
                  minWidth: context.width,
                ),
                child: ShadSelectFormField<String>(
                  enabled: editable,
                  label: Text("Monitored Value"),
                  options: _possibleMonitorValues.map(
                    (value) => ShadOption(
                      value: value,
                      child: Text(value),
                    ),
                  ),
                  selectedOptionBuilder: (context, value) => Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                      ),
                      child: Text(value)),
                  initialValue: alert?.monitoredValue.json,
                  onChanged: (v) {
                    monitoredValueController.text = v!;
                    _valuesChanged();
                  },
                  placeholder: Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                      ),
                      child: Text("Select a Value to Monitor")),
                ),
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: dangerPointController,
                label: Text("Danger Point"),
                keyboardType: TextInputType.number,
                initialValue: "1000",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: warningPointController,
                label: Text("Warning Point"),
                keyboardType: TextInputType.number,
                initialValue: "2500",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: dangerAlertIntervalController,
                label: Text("Danger Alert Interval (in days)"),
                keyboardType: TextInputType.number,
                initialValue: "1",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: warningAlertIntervalController,
                label: Text("Warning Alert Interval (in days)"),
                keyboardType: TextInputType.number,
                initialValue: "7",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              // tab panes to send based on users or roles
              ShadTabs(
                  value: alert != null
                      ? alert!.sendToRoles.isNotEmpty
                          ? "roles"
                          : "users"
                      : "roles",
                  tabs: [
                    ShadTab(
                      value: "roles",
                      content: ShadCard(
                        child: Column(
                          children: [
                            Text("Send This Alert To Roles"),
                            SizedBox(height: AppSizes.sm),
                            ShadSelect<Role>.multiple(
                              enabled: editable,
                              closeOnSelect: false,
                              onChanged: (v) {
                                sendToRoles.clear();
                                sendToRoles.addAll(v);
                                _valuesChanged();
                              },
                              anchor: ShadAnchorAuto(
                                preferBelow: false,
                              ),
                              options: userController.roles.map(
                                (r) => ShadOption(
                                  value: r,
                                  child: Text(r.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                AppColors.getRoleColorWithRole(
                                                    r),
                                          )),
                                ),
                              ),
                              selectedOptionsBuilder: (context, values) =>
                                  Container(
                                constraints: BoxConstraints(
                                  minWidth: context.width,
                                ),
                                child: Column(
                                  children: values
                                      .map((role) => Text(
                                            role.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors
                                                      .getRoleColorWithRole(
                                                          role),
                                                ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              initialValues: sendToRoles,
                              placeholder: Container(
                                  constraints: BoxConstraints(
                                    minWidth: context.width,
                                  ),
                                  child: Text("Select Roles")),
                            ),
                          ],
                        ),
                      ),
                      child: Text("Roles"),
                    ),
                    ShadTab(
                        value: "users",
                        content: ShadCard(
                          child: Column(
                            children: [
                              Text("Send This Alert To Users"),
                              SizedBox(height: AppSizes.sm),
                              ShadSelect<User>.multiple(
                                enabled: editable,
                                onChanged: (v) {
                                  sendToUsers.clear();
                                  sendToUsers.addAll(v);
                                  _valuesChanged();
                                },
                                closeOnSelect: false,
                                anchor: ShadAnchorAuto(
                                  preferBelow: false,
                                ),
                                options: _users.map(
                                  (user) => ShadOption(
                                    value: user,
                                    child: Text(getUserName(user),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors
                                                  .getRoleColorWithRoleValue(
                                                      user.role),
                                            )),
                                  ),
                                ),
                                selectedOptionsBuilder: (context, values) =>
                                    Container(
                                  constraints: BoxConstraints(
                                    minWidth: context.width,
                                  ),
                                  child: Column(
                                    children: values
                                        .map((user) => Text(
                                              getUserName(user),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors
                                                        .getRoleColorWithRoleValue(
                                                            user.role),
                                                  ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                initialValues: sendToUsers,
                                placeholder: Container(
                                    constraints: BoxConstraints(
                                      minWidth: context.width,
                                    ),
                                    child: Text("Select Users")),
                              ),
                            ],
                          ),
                        ),
                        child: Text("Users")),
                  ]),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: customMessageController,
                minLines: 4,
                maxLines: 30,
                label: Text("Custom Message"),
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.md),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShadCheckboxFormField(
                    enabled: editable,
                    initialValue: alert?.enabled ?? true,
                    inputLabel: Text("Enabled"),
                    onChanged: (v) {
                      enabled = v;
                      _valuesChanged();
                    },
                  ),
                ],
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
