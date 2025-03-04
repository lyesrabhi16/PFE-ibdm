import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class EmailAlertsPage extends StatefulWidget {
  const EmailAlertsPage({super.key});

  @override
  State<EmailAlertsPage> createState() => _EmailAlertsPageState();
}

class _EmailAlertsPageState extends State<EmailAlertsPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  late final strings = getTranslations(getContext).obs;

  final _showCheckboxColumn = false.obs;

  static final _searchController = TextEditingController();
  IbdmApiClient? api;
  final RxBool loaded = false.obs;

  RxList<AlertEmail> alerts = <AlertEmail>[].obs;
  late PaginatedAlertEmailList alertsMeta;

  final _selectedAlerts = <AlertEmail>[].obs;
  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return AppCustomContainer(
        child: Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Obx(() {
        if (!loaded.value) {
          load();
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        _showCheckboxColumn.value = _selectedAlerts.isNotEmpty;

        return Column(
          children: [
            Text(
              'Alert Emails',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: AppSizes.xl),
            Container(
              constraints: BoxConstraints(
                minWidth: context.width,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSizes.sm),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  runSpacing: AppSizes.sm,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    SearchBar(
                      controller: _searchController,
                      onSubmitted: (_) => _loadAlerts(),
                      onTapOutside: (_) => _loadAlerts(),
                      constraints: BoxConstraints(
                        maxWidth: AppSizes.lg * 8,
                        minHeight: AppSizes.lg * 1.5,
                        maxHeight: AppSizes.lg * 1.5,
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.surfaceContainer),
                      elevation: WidgetStatePropertyAll(0),
                      leading: Icon(Icons.search),
                      hintText: strings.value.search,
                    ),
                    Wrap(
                      children: [
                        ShadButton(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            hoverBackgroundColor:
                                colorScheme.surfaceContainerHighest,
                            foregroundColor: colorScheme.onSurface,
                            onPressed: () {
                              _showAddAlertEmailDialog();
                            },
                            child: Text(strings.value.addAlertEmail)),
                        ShadButton.destructive(
                            onPressed: _onDeleteButtonClick,
                            child: Text(strings.value.delete)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: context.width,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DataTable2(
                  columnSpacing: _getColumnSpacing(),
                  onSelectAll: (selectedAll) => selectedAll == true
                      ? _selectedAlerts.addAll(alerts)
                      : _selectedAlerts.clear(),
                  showCheckboxColumn: _showCheckboxColumn.value,
                  sortColumnIndex: 0,
                  dataRowColor: WidgetStateProperty.fromMap({
                    WidgetState.hovered:
                        Theme.of(context).colorScheme.primaryContainer,
                    WidgetState.focused: colorScheme.primaryContainer,
                  }),
                  columns: _getCols(),
                  rows: _getRows(),
                ),
              ),
            )
          ],
        );
      }),
    ));
  }

  _showAddAlertEmailDialog() {
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text("Add Alert Email",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text("Add a new alert email",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Save"),
            )
          ],
          child: AlertEmailForm(),
        );
      },
    );
  }

  void _onDeleteButtonClick({
    void Function()? onDeleteConfirmed,
  }) {
    _showCheckboxColumn.value = !_showCheckboxColumn.value;

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text("Delete Users"),
        description: Obx(
          () {
            return _selectedAlerts.isEmpty
                ? Text("Select Alerts to delete")
                : Text(
                    "Are you sure you want to delete ${_selectedAlerts.length} Alert(s)?");
          },
        ),
        action: Obx(
          () => _selectedAlerts.isEmpty
              ? ShadButton(
                  onPressed: () {
                    _selectedAlerts.clear();
                    _showCheckboxColumn.value = false;
                    ShadToaster.of(context).hide();
                  },
                  child: Text("Cancel"),
                )
              : Row(
                  children: [
                    ShadButton(
                      onPressed: () async {
                        await _deleteUsers();
                        load();
                        onDeleteConfirmed?.call();
                      },
                      child: Text("Yes"),
                    ),
                    ShadButton(
                      onPressed: () {
                        _selectedAlerts.clear();
                        _showCheckboxColumn.value = false;
                        ShadToaster.of(context).hide();
                      },
                      child: Text("No"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _loadAlerts() async {
    // Load alerts
    try {
      alertsMeta = await api!.getAlertEmails();
      alerts = alertsMeta.data.obs;
    } catch (e) {
      logger.e("Failed to load alerts : $e");
    }
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadAlerts();

    loaded.value = true;
  }

  _getCols() {
    return [
      DataColumn2(
          label: Text(
        strings.value.no,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.monitored,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.danger,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.warning,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.active,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
    ];
  }

  _getRows() {
    return alerts
        .map((e) => DataRow2(
                selected: _selectedAlerts.contains(e),
                onSelectChanged: (selected) {
                  if (selected == true) {
                    _selectedAlerts.add(e);
                  } else {
                    _selectedAlerts.remove(e);
                  }
                },
                cells: [
                  DataCell(Text(
                    (alerts.indexOf(e) + 1).toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(Text(
                    e.monitoredValue.json ?? "unknown",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(Text(
                    e.dangerPoint.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(Text(
                    e.warningPoint.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(
                    Checkbox(
                      value: e.enabled,
                      onChanged: (v) => print("checkbox state changed $v"),
                    ),
                  ),
                ]))
        .toList();
  }

  _getColumnSpacing() {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }

  void sort(int columnIndex, bool ascending) {
    print("sort called");
  }

  _deleteUsers() async {
    _done(int id) {
      alerts.removeWhere((element) => element.id == id);
    }

    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: "deleting alerts...",
        messageSuccess: "Alerts Deleted.",
        messageError: "Failed To delete alert/alerts",
        state: state);
    await Future.wait(_selectedAlerts.map((alert) {
      return api!.destroyAlertEmail(id: alert.id).then((value) {
        _done(alert.id);
      }).catchError((e) {
        logger.e("Failed to delete alert email : $e");
        state.value = FutureState.error;
        Toasts.showErrorToast(
            context: context,
            message: "Failed To delete alert with id: ${alert.id}");
      });
    }));
    if (state.value != FutureState.error) {
      state.value = FutureState.success;
    }
    load();
    Future.delayed(Duration(seconds: 2), () {
      toastification.dismissById(toast.id);
    });
    ShadToaster.of(Get.context!).hide();
  }
}

class AlertEmailForm extends StatelessWidget {
  AlertEmailForm({super.key, this.showIdField = false});

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  late final strings = getTranslations(getContext).obs;
  final bool showIdField;
  final userController = Get.find<UserController>();
  IbdmApiClient? api;
  List<User> _users = [];

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

  RxBool loaded = false.obs;
  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadUsers();

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

      return Form(
          child: Column(
        children: [
          SizedBox(height: AppSizes.lg),
          if (showIdField)
            ShadInputFormField(
              label: Text("id"),
            ),
          SizedBox(height: AppSizes.sm),
          Container(
            constraints: BoxConstraints(
              minWidth: context.width,
            ),
            child: ShadSelectFormField<String>(
              options: [
                ShadOption(
                  value: "1",
                  child: Text("Monitored Value"),
                ),
                ShadOption(
                  value: "2",
                  child: Text("Monitored Value 2"),
                ),
              ],
              selectedOptionBuilder: (context, value) => Container(
                  constraints: BoxConstraints(
                    minWidth: context.width,
                  ),
                  child: Text(value)),
              initialValue: null,
              placeholder: Container(
                  constraints: BoxConstraints(
                    minWidth: context.width,
                  ),
                  child: Text("Select a Value to Monitor")),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          ShadInputFormField(
            label: Text("Danger Point"),
            keyboardType: TextInputType.number,
            initialValue: "1000",
          ),
          SizedBox(height: AppSizes.sm),
          ShadInputFormField(
            label: Text("Warning Point"),
            keyboardType: TextInputType.number,
            initialValue: "2500",
          ),
          SizedBox(height: AppSizes.sm),
          ShadInputFormField(
            label: Text("Danger Alert Interval (in days)"),
            keyboardType: TextInputType.number,
            initialValue: "1",
          ),
          SizedBox(height: AppSizes.sm),
          ShadInputFormField(
            label: Text("Warning Alert Interval (in days)"),
            keyboardType: TextInputType.number,
            initialValue: "7",
          ),
          SizedBox(height: AppSizes.sm),
          // tab panes to send based on users or roles
          ShadTabs(value: "roles", tabs: [
            ShadTab(
              value: "roles",
              content: ShadCard(
                child: Column(
                  children: [
                    Text("Send This Alert To Roles"),
                    SizedBox(height: AppSizes.sm),
                    ShadSelect<Role>.multiple(
                      closeOnSelect: false,
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
                                    color: AppColors.getRoleColorWithRole(r),
                                  )),
                        ),
                      ),
                      selectedOptionsBuilder: (context, values) => Container(
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
                                          color: AppColors.getRoleColorWithRole(
                                              role),
                                        ),
                                  ))
                              .toList(),
                        ),
                      ),
                      initialValues: [],
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
                                      color:
                                          AppColors.getRoleColorWithRoleValue(
                                              user.role),
                                    )),
                          ),
                        ),
                        selectedOptionsBuilder: (context, values) => Container(
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
                        initialValues: [],
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
            minLines: 4,
            maxLines: 30,
            label: Text("Custom Message"),
          ),
          SizedBox(height: AppSizes.md),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShadCheckboxFormField(
                initialValue: true,
                inputLabel: Text("Enabled"),
                onChanged: (v) {},
              ),
            ],
          ),
          SizedBox(height: AppSizes.lg),
        ],
      ));
    });
  }
}
