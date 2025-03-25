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

class EmailScheduleForm extends StatelessWidget {
  EmailScheduleForm({
    super.key,
    this.showIdField = false,
    this.onValuesChanged,
    this.editable = true,
    this.schedule,
    this.showNextRunTime = false,
  });

  final bool editable;
  final EmailSchedule? schedule;

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final Function({
    RapportEnum? rapport,
    String? tempsEnvoi,
    IntervalEnum? interval,
    int? intervalManual,
    DateTime? nextRunTime,
    List<Role>? roles,
    List<User>? users,
  })? onValuesChanged;

  _valuesChanged() {
    if (!editable) return;
    print("interval: ${interval!.value}");
    print("nextRunTime: ${nextRunTime}");
    onValuesChanged?.call(
      rapport: rapport,
      tempsEnvoi:
          "${tempsEnvoi!.hour}:${tempsEnvoi!.minute}:${tempsEnvoi!.second}",
      interval: interval!.value,
      intervalManual: int.tryParse(intervalManualController.text),
      nextRunTime: nextRunTime,
      roles: sendToRoles.toList(),
      users: sendToUsers.toList(),
    );
  }

  final idController = TextEditingController(text: "Auto Generated");
  RapportEnum? rapport;
  ShadTimeOfDay? tempsEnvoi;
  Rx<IntervalEnum>? interval;
  final intervalManualController = TextEditingController(text: "1");
  DateTime? nextRunTime;
  final sendToRoles = <Role>[];
  final sendToUsers = <User>[];

  bool enabled = true;

  late final strings = getTranslations(getContext).obs;
  final bool showIdField;
  final userController = Get.find<UserController>();
  IbdmApiClient? api;
  List<User> _users = [];
  List<RapportEnum> _rapportValues = [];
  RxBool loaded = false.obs;

  bool showNextRunTime;
  final RxBool _showNextRunTime = false.obs;

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

    _rapportValues =
        RapportEnum.values.where((r) => r != RapportEnum.$unknown).toList();
    // await _loadPossibleMonitorValues();
    _showNextRunTime.value = showNextRunTime;
    if (schedule != null) {
      idController.text = schedule!.id.toString();
      rapport = schedule!.rapport;
      final tempsEnvoiIntList = schedule!.tempsEnvoi
          .split(":")
          .map((s) => int.tryParse(s) ?? 0)
          .toList();
      tempsEnvoi = ShadTimeOfDay(
        hour: tempsEnvoiIntList[0],
        minute: tempsEnvoiIntList[1],
        second: 0,
      );
      interval = (schedule!.interval).obs;
      intervalManualController.text = schedule!.intervalManual.toString();
      nextRunTime = schedule!.nextRunTime;
      sendToRoles.addAll(
        userController.roles
            .where((role) => schedule!.scheduledRoles.contains(role.roleId)),
      );
      sendToUsers.addAll(
        _users.where((user) => schedule!.scheduledUsers.contains(user.email)),
      );
    }
    interval ??= (IntervalEnum.jour).obs;
    rapport ??= RapportEnum.values.first;
    tempsEnvoi ??= ShadTimeOfDay(
      hour: DateTime.now().hour,
      minute: DateTime.now().minute,
      second: 0,
    );
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
          child: Obx(() {
            return Column(
              children: [
                SizedBox(height: AppSizes.lg),
                if (showIdField)
                  ShadInputFormField(
                    enabled: editable,
                    controller: idController,
                    label: Text(strings.value.id),
                  ),
                SizedBox(height: AppSizes.sm),
                Container(
                  constraints: BoxConstraints(
                    minWidth: context.width,
                  ),
                  child: ShadSelectFormField<RapportEnum>(
                    enabled: editable,
                    label: Text(strings.value.rapport),
                    options: _rapportValues.map(
                      (value) => ShadOption(
                        value: value,
                        child: Text(value.json ?? strings.value.unknown),
                      ),
                    ),
                    selectedOptionBuilder: (context, value) => Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        child: Text(value.json ?? strings.value.unknown)),
                    initialValue: schedule?.rapport ?? rapport,
                    onChanged: (v) {
                      rapport = v;
                      _valuesChanged();
                    },
                    placeholder: Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        child: Text(strings.value.selectAReport)),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                Container(
                  constraints: BoxConstraints(
                    minWidth: context.width,
                  ),
                  child: ShadSelectFormField<IntervalEnum>(
                    enabled: editable,
                    label: Text(strings.value.interval),
                    options: IntervalEnum.values
                        .where((i) => i != IntervalEnum.$unknown)
                        .map(
                          (value) => ShadOption(
                            value: value,
                            child: Text(value.json ?? strings.value.unknown),
                          ),
                        ),
                    selectedOptionBuilder: (context, value) => Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        child: Text(value.json ?? strings.value.unknown)),
                    initialValue: schedule?.interval ?? interval?.value,
                    onChanged: (v) {
                      print("set interval: $v");
                      interval!.value = v!;
                      print("interval set: ${interval!.value}");
                      _valuesChanged();
                    },
                    placeholder: Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        child: Text(strings.value.selectAnInterval)),
                  ),
                ),
                SizedBox(height: AppSizes.sm),
                if (interval!.value == IntervalEnum.manual)
                  ShadInputFormField(
                    enabled: editable,
                    controller: intervalManualController,
                    label: Text(strings.value.intervalManualLabel),
                    keyboardType: TextInputType.number,
                    initialValue: "1",
                    onChanged: (v) => {
                      _valuesChanged(),
                    },
                  ),
                SizedBox(height: AppSizes.sm),
                ShadTimePickerFormField(
                  enabled: editable,
                  label: Text(strings.value.tempsEnvoi),
                  maxSecond: 0,
                  initialValue: tempsEnvoi!,
                  onChanged: (v) => {
                    tempsEnvoi = v,
                    _valuesChanged(),
                  },
                ),
                SizedBox(height: AppSizes.sm),

                // tab panes to send based on users or roles
                ShadTabs(
                    value: schedule != null
                        ? schedule!.scheduledRoles.isNotEmpty
                            ? strings.value.roles
                            : strings.value.users
                        : strings.value.roles,
                    tabs: [
                      ShadTab(
                        value: strings.value.roles,
                        content: ShadCard(
                          child: Column(
                            children: [
                              Text(strings.value.sendThisAlertToRoles),
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
                                              color: AppColors
                                                  .getRoleColorWithRole(r),
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
                                    child: Text(strings.value.selectRoles)),
                              ),
                            ],
                          ),
                        ),
                        child: Text(strings.value.roles),
                      ),
                      ShadTab(
                          value: strings.value.users,
                          content: ShadCard(
                            child: Column(
                              children: [
                                Text(strings.value.sendThisAlertToUsers),
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
                                      child: Text(strings.value.selectUsers)),
                                ),
                              ],
                            ),
                          ),
                          child: Text(strings.value.users)),
                    ]),
                SizedBox(height: AppSizes.sm),
                if (editable)
                  ShadSwitchFormField(
                    enabled: editable,
                    inputLabel: Text(strings.value.scheduleManually),
                    initialValue: _showNextRunTime.value,
                    onChanged: (v) => {
                      _showNextRunTime.value = v,
                    },
                  ),
                SizedBox(height: AppSizes.sm),
                if (!editable || _showNextRunTime.value)
                  Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        ),
                        child: ShadDatePickerFormField(
                          enabled: editable,
                          label: Text(strings.value.nextRunTimeDate),
                          formatDate: (date) =>
                              "${date.day}/${date.month}/${date.year}",
                          initialValue: schedule?.nextRunTime ?? DateTime.now(),
                          onChanged: (v) => {
                            nextRunTime = DateTime(
                              v!.year,
                              v.month,
                              v.day,
                              nextRunTime?.hour ?? v.hour,
                              nextRunTime?.minute ?? v.minute,
                            ),
                            _valuesChanged(),
                          },
                        ),
                      ),
                      SizedBox(width: AppSizes.md),
                      Expanded(
                        child: ShadTimePickerFormField(
                          enabled: editable,
                          label: Text(strings.value.nextRunTimeTime),
                          initialValue: ShadTimeOfDay(
                            hour: schedule?.nextRunTime?.hour ??
                                DateTime.now().hour,
                            minute: schedule?.nextRunTime?.minute ??
                                DateTime.now().minute,
                            second: 0,
                          ),
                          maxSecond: 0,
                          onChanged: (v) => {
                            if (v != null)
                              {
                                nextRunTime = DateTime(
                                  nextRunTime!.year,
                                  nextRunTime!.month,
                                  nextRunTime!.day,
                                  v.hour,
                                  v.minute,
                                ),
                              },
                            _valuesChanged(),
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            );
          }));
    });
  }
}
