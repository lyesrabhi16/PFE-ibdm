import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/alert_email_form.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/page_navigation.dart';
import 'package:ibdm/common/widgets/per_page_input.dart';
import 'package:ibdm/common/widgets/scrollable_shad_sheet_container.dart';
import 'package:ibdm/pages/settings/emails/actions.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/common_heplers.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/sorter.dart';
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

  final _showCheckboxColumn = false.obs;

  static final _searchController = TextEditingController();
  IbdmApiClient? api;
  final RxBool loaded = false.obs;
  final RxBool _isDataLoading = false.obs;

  RxList<AlertEmail> alerts = <AlertEmail>[].obs;
  late PaginatedAlertEmailList alertsMeta;
  final _selectedAlerts = <AlertEmail>[].obs;

  List<String> _allMonitorValueTags = <String>[];

  int page = 1;
  String? monitorValueTagFilter;
  bool? activationStateFilter;

  int? lastPerPage;
  String? lastSearch;

  static final _expandPerPage = false.obs;
  static final _perPageController = TextEditingController(text: "10");

  static final _filtersPopoverController = ShadPopoverController();
  static final _filtersActive = false.obs;

  final GlobalKey<ShadFormState> _formKey = GlobalKey<ShadFormState>();

  static final _perPageFormKey = GlobalKey<FormState>();

  static final _tagFilterController = TextEditingController();
  static final _activationStateFilterController = TextEditingController();

  static final _sortPopoverController = ShadPopoverController();

  final RxMap<String, Sorter> _sortersASC = {
    "Monitored Value": Sorter(
      isSelected: false,
      orderingValue: "monitored_value",
    ),
    "Danger Point": Sorter(
      isSelected: false,
      orderingValue: "danger_point",
    ),
    "Warning Point": Sorter(
      isSelected: false,
      orderingValue: "warning_point",
    ),
    "Enabled": Sorter(
      isSelected: false,
      orderingValue: "enabled",
    ),
  }.obs;
  final RxMap<String, Sorter> _sortersDESC = {
    "Monitored Value": Sorter(
      isSelected: false,
      orderingValue: "-monitored_value",
    ),
    "Danger Point": Sorter(
      isSelected: false,
      orderingValue: "-danger_point",
    ),
    "Warning Point": Sorter(
      isSelected: false,
      orderingValue: "-warning_point",
    ),
    "Enabled": Sorter(
      isSelected: false,
      orderingValue: "-enabled",
    ),
  }.obs;

  final _sortASC = true.obs;

  final _sortActive = false.obs;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    return AppCustomContainer(
        backButton: true,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: max(context.height - AppSizes.heightOffset * 2, 600),
              maxHeight: max(context.height - AppSizes.heightOffset * 2, 600),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Obx(() {
                if (!loaded.value) {
                  load();
                  return CircularProgressIndicatorWithText(
                    text: strings.value.loading,
                  );
                }

                _showCheckboxColumn.value = _selectedAlerts.isNotEmpty;

                return Column(
                  children: [
                    Text(
                      strings.value.emailAlerts,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.sm),
                        child: Wrap(
                          alignment: isAtMostSmallScreen(context)
                              ? WrapAlignment.center
                              : WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          runSpacing: AppSizes.sm,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            SearchBar(
                              controller: _searchController,
                              onSubmitted: (_) =>
                                  _searchController.text != lastSearch
                                      ? {page = 1, _loadAlerts()}
                                      : null,
                              onTapOutside: (_) =>
                                  _searchController.text != lastSearch
                                      ? {page = 1, _loadAlerts()}
                                      : null,
                              constraints: BoxConstraints(
                                maxWidth: AppSizes.lg * 8,
                                minHeight: AppSizes.lg * 1.5,
                                maxHeight: AppSizes.lg * 1.5,
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer),
                              elevation: WidgetStatePropertyAll(0),
                              leading: Icon(Icons.search),
                              hintText: strings.value.search,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                ShadButton(
                                    backgroundColor:
                                        colorScheme.surfaceContainerLow,
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: AppSizes.xl * 4,
                                    child: IconWithLabelButton(
                                      icon: Icons.settings,
                                      text: strings.value.options,
                                      onTap: () {
                                        showShadSheet(
                                            context: context,
                                            side: ShadSheetSide.right,
                                            isDismissible: true,
                                            builder: (context) {
                                              return ScrollableShadSheetContainer(
                                                child:
                                                    _topPageActionsSmallScreen(),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ).removeWhen(isAtLeastMediumScreen(context)),
                              ].nonNulls.toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                          width: context.width,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: _topPageActions(
                            alignment: WrapAlignment.spaceBetween,
                            expandPerPage: _expandPerPage.value,
                            filtersPopoverController: _filtersPopoverController,
                            filtersActive: _filtersActive,
                            perPageFormKey: _perPageFormKey,
                            tagFilterController: _tagFilterController,
                            activationStateFilterController:
                                _activationStateFilterController,
                            sortPopoverController: _sortPopoverController,
                            sortASC: _sortASC,
                            sortActive: _sortActive,
                          ),
                        ).removeWhen(isAtMostSmallScreen(context)) ??
                        SizedBox.shrink(),
                    SizedBox(
                      height: AppSizes.sm,
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadius),
                        ),
                        child: _isDataLoading.value
                            ? CircularProgressIndicatorWithText(
                                text: strings.value.loadingAlerts,
                              )
                            : DataTable2(
                                columnSpacing: _getColumnSpacing(),
                                onSelectAll: (selectedAll) =>
                                    selectedAll == true
                                        ? _selectedAlerts.addAll(alerts)
                                        : _selectedAlerts.clear(),
                                showCheckboxColumn: _showCheckboxColumn.value,
                                sortColumnIndex: 0,
                                dataRowColor: WidgetStateProperty.fromMap({
                                  WidgetState.hovered: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  WidgetState.focused:
                                      colorScheme.primaryContainer,
                                }),
                                columns: _getCols(),
                                rows: _getRows(),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.sm,
                    ),
                    _bottomPageActions(
                      currentPage: alertsMeta.currentPage,
                      nbrTotalPages: alertsMeta.totalPages,
                      nbrShown: alertsMeta.data.length,
                      nbrTotal: alertsMeta.totalResults,
                      onPrevPress: (p) => {page = p, _loadAlerts()},
                      onNextPress: (p) => {page = p, _loadAlerts()},
                      onPagePress: (p) => {page = p, _loadAlerts()},
                      data: alerts,
                      label: strings.value.alerts,
                    )
                  ],
                );
              }),
            ),
          ),
        ));
  }

  _showAddAlertEmailDialog() {
    String? _addAlertCustomMessage;
    String? _addAlertDangerAlertInterval;
    String? _addAlertDangerPoint;
    bool? _addAlertEnabled;
    String? _addAlertMonitoredValue;
    String? _addAlertMonitorType;
    List<Role>? _addAlertRoles;
    List<User>? _addAlertUsers;
    String? _addAlertWarningAlertInterval;
    String? _addAlertWarningPoint;
    ReminderIntervalUnitEnum? _addAlertReminderIntervalUnit;

    return showShadDialog(
      context: context,
      builder: (context) {
        final strings = getTranslations(context).obs;
        return ShadDialog(
          title: Text(strings.value.addAlertEmail,
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(strings.value.addANewAlertEmail,
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(strings.value.close),
            ),
            ShadButton(
              onPressed: () {
                EmailActions.addAlert(
                  context,
                  getUniqueId(),
                  formState: _formKey.currentState,
                  monitoredValue: _addAlertMonitoredValue!,
                  monitorType: _addAlertMonitorType,
                  customMessage: _addAlertCustomMessage,
                  dangerAlertInterval: _addAlertDangerAlertInterval,
                  dangerPoint: _addAlertDangerPoint,
                  enabled: _addAlertEnabled,
                  roles: _addAlertRoles,
                  users: _addAlertUsers,
                  warningAlertInterval: _addAlertWarningAlertInterval,
                  warningPoint: _addAlertWarningPoint,
                  reminderIntervalUnit: _addAlertReminderIntervalUnit,
                  onSuccess: () {
                    _loadAlerts();
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Text(strings.value.add),
            )
          ],
          child: AlertEmailForm(
            formKey: _formKey,
            onValuesChanged: ({
              customMessage,
              dangerAlertInterval,
              dangerPoint,
              enabled,
              monitoredValue,
              monitorType,
              roles,
              users,
              warningAlertInterval,
              warningPoint,
              reminderIntervalUnit,
            }) {
              _addAlertCustomMessage = customMessage;
              _addAlertDangerAlertInterval = dangerAlertInterval;
              _addAlertDangerPoint = dangerPoint;
              _addAlertEnabled = enabled;
              printMessage("monitoredValue : $monitoredValue");
              _addAlertMonitoredValue = monitoredValue;
              printMessage("monitorType : $monitorType");
              _addAlertMonitorType = monitorType;
              _addAlertRoles = roles;
              _addAlertUsers = users;
              _formKey.currentState?.validate();
              _addAlertWarningAlertInterval = warningAlertInterval;
              _addAlertWarningPoint = warningPoint;
              _addAlertReminderIntervalUnit = reminderIntervalUnit;
            },
          ),
        ).marginOnly(
          top: AppSizes.md,
        );
      },
    );
  }

  _showViewAlertEmailDialog({
    required AlertEmail alert,
  }) {
    final strings = getTranslations(context).obs;
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text("${strings.value.alerts}: ${alert.monitoredValue.json} ",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(
              strings.value.viewAlertSettingsOf(alert.monitoredValue.json!),
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              icon: Icon(Icons.close),
              child: Text(strings.value.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton.destructive(
                      child: Text(strings.value.delete),
                      onPressed: () {
                        _selectedAlerts.add(alert);
                        _onDeleteButtonClick(
                          onDeleteConfirmed: () => Navigator.of(context).pop(),
                        );
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton(
                      icon: Icon(Icons.edit),
                      child: Text(strings.value.edit),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showEditAlertEmailDialog(alert: alert);
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() => Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loaded.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShadButton.destructive(
                              child: Text(strings.value.delete),
                              onPressed: () {
                                _selectedAlerts.add(alert);
                                _onDeleteButtonClick(
                                  onDeleteConfirmed: () =>
                                      Navigator.of(context).pop(),
                                );
                              },
                            ),
                            ShadButton(
                              icon: Icon(Icons.edit),
                              child: Text(strings.value.edit),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showEditAlertEmailDialog(alert: alert);
                              },
                            ),
                          ],
                        ),
                      ShadButton(
                        icon: Icon(Icons.close),
                        child: Text(strings.value.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )).removeWhen(isAtMostSmallScreen(context))
          ].nonNulls.toList(),
          child: AlertEmailForm(
            alert: alert,
            editable: false,
            showIdField: true,
            formKey: _formKey,
          ),
        ).marginOnly(
          top: AppSizes.md,
        );
      },
    );
  }

  _showEditAlertEmailDialog({
    required AlertEmail alert,
  }) {
    final strings = getTranslations(context).obs;
    String? _saveAlertCustomMessage;
    String? _saveAlertDangerAlertInterval;
    String? _saveAlertDangerPoint;
    bool? _saveAlertEnabled;
    String? _saveAlertMonitoredValue;
    String? _saveAlertMonitorType;
    List<Role>? _saveAlertRoles;
    List<User>? _saveAlertUsers;
    String? _saveAlertWarningAlertInterval;
    String? _saveAlertWarningPoint;
    ReminderIntervalUnitEnum? _saveAlertReminderIntervalUnit;
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(
              "${strings.value.editAlert} : ${alert.monitoredValue.json} ",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(
              strings.value.editAlertSettingsOf(alert.monitoredValue.json!),
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              icon: Icon(Icons.close),
              child: Text(strings.value.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton.destructive(
                      child: Text(strings.value.delete),
                      onPressed: () {
                        _selectedAlerts.add(alert);
                        _onDeleteButtonClick(
                          onDeleteConfirmed: () => Navigator.of(context).pop(),
                        );
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton(
                      icon: Icon(Icons.edit),
                      child: Text(strings.value.save),
                      onPressed: () {
                        EmailActions.saveAlert(
                          context,
                          getUniqueId(),
                          formState: _formKey.currentState,
                          alertId: alert.id,
                          customMessage: _saveAlertCustomMessage,
                          dangerAlertInterval: _saveAlertDangerAlertInterval,
                          dangerPoint: _saveAlertDangerPoint,
                          enabled: _saveAlertEnabled,
                          monitoredValue: _saveAlertMonitoredValue,
                          monitorType: _saveAlertMonitorType,
                          roles: _saveAlertRoles,
                          users: _saveAlertUsers,
                          warningAlertInterval: _saveAlertWarningAlertInterval,
                          warningPoint: _saveAlertWarningPoint,
                          reminderIntervalUnit: _saveAlertReminderIntervalUnit,
                          onSuccess: () {
                            _loadAlerts();
                            Navigator.of(context).pop();
                          },
                        );

                        // logger.e("Failed to save alert : $e");
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() => Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loaded.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShadButton.destructive(
                              child: Text(strings.value.delete),
                              onPressed: () {
                                _selectedAlerts.add(alert);
                                _onDeleteButtonClick(
                                  onDeleteConfirmed: () =>
                                      Navigator.of(context).pop(),
                                );
                              },
                            ),
                            ShadButton(
                              icon: Icon(Icons.edit),
                              child: Text(strings.value.save),
                              onPressed: () {
                                EmailActions.saveAlert(
                                  context,
                                  getUniqueId(),
                                  formState: _formKey.currentState,
                                  alertId: alert.id,
                                  customMessage: _saveAlertCustomMessage,
                                  dangerAlertInterval:
                                      _saveAlertDangerAlertInterval,
                                  dangerPoint: _saveAlertDangerPoint,
                                  enabled: _saveAlertEnabled,
                                  monitoredValue: _saveAlertMonitoredValue,
                                  monitorType: _saveAlertMonitorType,
                                  roles: _saveAlertRoles,
                                  users: _saveAlertUsers,
                                  warningAlertInterval:
                                      _saveAlertWarningAlertInterval,
                                  warningPoint: _saveAlertWarningPoint,
                                  reminderIntervalUnit:
                                      _saveAlertReminderIntervalUnit,
                                  onSuccess: () {
                                    _loadAlerts();
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ShadButton(
                        icon: Icon(Icons.close),
                        child: Text(strings.value.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )).removeWhen(isAtMostSmallScreen(context))
          ].nonNulls.toList(),
          child: AlertEmailForm(
            formKey: _formKey,
            alert: alert,
            editable: true,
            showIdField: false,
            onValuesChanged: ({
              customMessage,
              dangerAlertInterval,
              dangerPoint,
              enabled,
              monitoredValue,
              monitorType,
              roles,
              users,
              warningAlertInterval,
              warningPoint,
              reminderIntervalUnit,
            }) {
              if (customMessage != null) {
                _saveAlertCustomMessage =
                    customMessage.isNotEmpty ? customMessage : null;
              }
              if (dangerAlertInterval != null) {
                _saveAlertDangerAlertInterval =
                    dangerAlertInterval.isNotEmpty ? dangerAlertInterval : null;
              }
              if (dangerPoint != null) {
                _saveAlertDangerPoint =
                    dangerPoint.isNotEmpty ? dangerPoint : null;
              }
              _saveAlertEnabled = enabled;
              if (monitoredValue != null) {
                _saveAlertMonitoredValue =
                    monitoredValue.isNotEmpty ? monitoredValue : null;
              }
              if (monitorType != null) {
                _saveAlertMonitorType =
                    monitorType.isNotEmpty ? monitorType : null;
              }
              _saveAlertRoles = roles;
              _saveAlertUsers = users;

              if (warningAlertInterval != null) {
                _saveAlertWarningAlertInterval = warningAlertInterval.isNotEmpty
                    ? warningAlertInterval
                    : null;
              }
              if (warningPoint != null) {
                _saveAlertWarningPoint =
                    warningPoint.isNotEmpty ? warningPoint : null;
              }
              if (reminderIntervalUnit != null) {
                _saveAlertReminderIntervalUnit = reminderIntervalUnit;
              }
            },
          ),
        ).marginOnly(
          top: AppSizes.md,
        );
      },
    );
  }

  void _onDeleteButtonClick({
    void Function()? onDeleteConfirmed,
  }) {
    final strings = getTranslations(context).obs;
    _showCheckboxColumn.value = !_showCheckboxColumn.value;

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text(strings.value.deleteAlerts),
        description: Obx(
          () {
            return _selectedAlerts.isEmpty
                ? Text(strings.value.selectAlertsToDelete)
                : Text(strings.value
                    .confirmAlertsDeletion(_selectedAlerts.length));
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
                  child: Text(strings.value.close),
                )
              : Row(
                  children: [
                    ShadButton(
                      onPressed: () async {
                        await _deleteAlerts();
                        _loadAlerts();
                        onDeleteConfirmed?.call();
                      },
                      child: Text(strings.value.yes),
                    ),
                    ShadButton(
                      onPressed: () {
                        _selectedAlerts.clear();
                        _showCheckboxColumn.value = false;
                        ShadToaster.of(context).hide();
                      },
                      child: Text(strings.value.no),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _bottomPageActions({
    required int currentPage,
    required int nbrTotalPages,
    required int nbrShown,
    required int nbrTotal,
    required Function(int page) onPrevPress,
    required Function(int page) onNextPress,
    required Function(int page) onPagePress,
    required List<Object> data,
    required String label,
  }) {
    return PageNavigation(
      currentPage: currentPage,
      nbrTotalPages: nbrTotalPages,
      nbrShown: nbrShown,
      nbrTotal: nbrTotal,
      onPrevPress: onPrevPress,
      onNextPress: onNextPress,
      onPagePress: onPagePress,
      label: label,
    );
  }

  Future<void> _loadAlerts() async {
    final strings = getTranslations(context);
    _isDataLoading.value = true;
    _getOrdering() {
      return _sortASC.value
          ? _sortersASC.entries
              .where((e) => e.value.isSelected)
              .firstOrNull
              ?.value
              .orderingValue
          : _sortersDESC.entries
              .where((e) => e.value.isSelected)
              .firstOrNull
              ?.value
              .orderingValue;
    }

    // Load alerts
    try {
      lastSearch = _searchController.text;
      lastPerPage = int.tryParse(_perPageController.text);
      alertsMeta = await api!.getAlertEmails(
        page: page,
        perPage: int.tryParse(_perPageController.text),
        tag: monitorValueTagFilter,
        enabled: activationStateFilter,
        ordering: _getOrdering(),
        search:
            _searchController.text.isNotEmpty ? _searchController.text : null,
      );
      alerts = alertsMeta.data.obs;
    } catch (e) {
      logger.e("Failed to load alerts : $e");
      Toasts.showErrorToastNotification(
          context: context, message: strings.failedToLoadAlerts);
    }
    _isDataLoading.value = false;
  }

  Future<void> _loadAllTags() async {
    final strings = getTranslations(context);
    // Load alerts
    try {
      final res = await api!.getPossibleMonitorValuesAlertEmails();
      _allMonitorValueTags =
          res.allValues.map((mv) => mv.split(".")[0]).toSet().toList();
    } catch (e) {
      logger.e("Failed to load alerts : $e");
      Toasts.showErrorToastNotification(
          context: context, message: strings.failedToLoadTags);
    }
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    // use stored perPage if it exists
    int? perPageInStorage = await LocalStorage.getPerPage();
    if (perPageInStorage != null) {
      _perPageController.text = perPageInStorage.toString();
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadAlerts();
    await _loadAllTags();

    loaded.value = true;
  }

  _getCols() {
    final strings = getTranslations(context).obs;

    return [
      DataColumn2(
          fixedWidth: 60,
          label: Text(
            strings.value.num,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: ColumnSize.L,
          label: Text(
            strings.value.monitored,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )),
      DataColumn2(
          size: ColumnSize.S,
          label: Text(
            strings.value.danger,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: ColumnSize.S,
          label: Text(
            strings.value.warning,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: ColumnSize.S,
          label: Text(
            strings.value.active,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )),
      DataColumn2(
        size: ColumnSize.S,
        label: Expanded(
          child: Text(
            strings.value.actions,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    ].nonNulls.toList();
  }

  _getRows() {
    final strings = getTranslations(context).obs;
    return alerts.map((e) {
      final actionsController = ShadPopoverController();
      return DataRow2(
        selected: _selectedAlerts.contains(e),
        onSelectChanged: (selected) {
          if (selected == true) {
            _selectedAlerts.add(e);
          } else {
            _selectedAlerts.remove(e);
          }
        },
        onDoubleTap: () => _showViewAlertEmailDialog(
          alert: e,
        ),
        cells: [
          DataCell(Text(
            (alerts.indexOf(e) + 1).toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(FittedBox(
            child: Text(
              e.monitoredValue.json ?? strings.value.unknown,
              softWrap: false,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )),
          DataCell(Text(
            e.dangerPoint.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: errorColor,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(Text(
            e.warningPoint.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(
            Checkbox(
              value: e.enabled,
              onChanged: (v) {
                EmailActions.changeAlertEnabledState(
                  context,
                  alert: e,
                  enabled: v ?? false,
                  onSuccess: () {
                    _loadAlerts();
                  },
                );
              },
            ),
          ),
          DataCell(
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      _showViewAlertEmailDialog(alert: e);
                    },
                    icon: Icon(Icons.remove_red_eye_rounded),
                  ).removeWhen(isAtMostMediumScreen(context)),
                  IconButton(
                    onPressed: () {
                      _showEditAlertEmailDialog(alert: e);
                    },
                    icon: Icon(Icons.edit),
                  ).removeWhen(isAtMostSmallScreen(context)),
                  IconButton(
                    onPressed: () {
                      _selectedAlerts.add(e);
                      _onDeleteButtonClick();
                    },
                    icon: Icon(Icons.delete),
                  ).removeWhen(isAtMostMediumScreen(context)),
                  ShadPopover(
                    padding: EdgeInsets.zero,
                    decoration: ShadDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(AppSizes.borderRadius),
                        )),
                    popover: (context) => SizedBox(
                      width: AppSizes.lg * 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconWithLabelButton(
                            icon: Icons.remove_red_eye_rounded,
                            text: strings.value.view,
                            onTap: () => {
                              _showViewAlertEmailDialog(alert: e),
                              actionsController.toggle(),
                            },
                          ),
                          IconWithLabelButton(
                            icon: Icons.edit,
                            onTap: () {
                              _showEditAlertEmailDialog(alert: e);
                              actionsController.toggle();
                            },
                            text: strings.value.edit,
                          ).removeWhen(isAtLeastMediumScreen(context)),
                          IconWithLabelButton(
                            icon: Icons.delete,
                            text: strings.value.delete,
                            onTap: () {
                              _selectedAlerts.add(e);
                              _onDeleteButtonClick(
                                onDeleteConfirmed: () =>
                                    actionsController.toggle(),
                              );
                            },
                            activeColor: errorColor,
                          ),
                        ].nonNulls.toList(),
                      ),
                    ),
                    controller: actionsController,
                    child: IconButton(
                      onPressed: () {
                        actionsController.toggle();
                      },
                      icon: Icon(
                        LucideIcons.ellipsisVertical,
                        applyTextScaling: true,
                      ),
                    ),
                  ).removeWhen(isAtLeastLargeScreen(context)),
                ].nonNulls.toList(),
              ),
            ),
          ),
        ].nonNulls.toList(),
      );
    }).toList();
  }

  _getColumnSpacing() {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }

  _deleteAlerts() async {
    final strings = getTranslations(context).obs;
    _done(int id) {
      _selectedAlerts.removeWhere((element) => element.id == id);
      alerts.removeWhere((element) => element.id == id);
    }

    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: strings.value.deletingAlerts,
        messageSuccess: strings.value.alertsDeleted,
        messageError: strings.value.failedToDeleteAlerts,
        state: state);
    await Future.wait(_selectedAlerts.map((alert) {
      return api!.destroyAlertEmail(id: alert.id).then((value) {
        _done(alert.id);
      }).catchError((e) {
        logger.e("Failed to delete alert email : $e");
        state.value = FutureState.error;
        Toasts.showErrorToast(
            context: context,
            message: strings.value.failedToDeleteAlertWithId(alert.id));
      });
    }));
    if (state.value != FutureState.error) {
      state.value = FutureState.success;
    }
    Future.delayed(Duration(seconds: 2), () {
      toastification.dismissById(toast.id);
    });
    ShadToaster.of(context).hide();
  }

  _topPageActions({
    WrapAlignment alignment = WrapAlignment.spaceBetween,
    bool reverseOrder = false,
    bool expandPerPage = false,
    double? customExpandPerPage,
    required ShadPopoverController filtersPopoverController,
    required RxBool filtersActive,
    required GlobalKey<FormState> perPageFormKey,
    required TextEditingController tagFilterController,
    required TextEditingController activationStateFilterController,
    required ShadPopoverController sortPopoverController,
    required RxBool sortASC,
    required RxBool sortActive,
  }) {
    final context = getContext;
    final strings = getTranslations(context).obs;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Wrap(
        alignment: alignment,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        verticalDirection: VerticalDirection.down,
        textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // left row
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              // filter button
              SizedBox(
                width: AppSizes.xl * 4,
                child: ShadPopover(
                  controller: filtersPopoverController,
                  decoration: ShadDecoration(
                    border: ShadBorder.none,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  closeOnTapOutside: false,
                  popover: (context) => Container(
                    constraints: BoxConstraints(
                      minWidth: AppSizes.xl * 6,
                      maxWidth: AppSizes.xl * 8,
                      maxHeight: context.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: filterContent(context, tagFilterController,
                          activationStateFilterController),
                    ),
                  ),
                  child: IconWithLabelButton(
                    icon: Icons.filter_alt,
                    active: filtersActive.value,
                    text: strings.value.filter,
                    onTap: () {
                      filtersActive.value = !filtersActive.value;
                      filtersPopoverController.toggle();
                    },
                  ),
                ),
              ),
              // sort button
              SizedBox(
                width: AppSizes.xl * 4,
                child: ShadPopover(
                  controller: sortPopoverController,
                  decoration: ShadDecoration(
                    border: ShadBorder.none,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  closeOnTapOutside: false,
                  popover: (context) => ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: AppSizes.xl * 6,
                      maxWidth: AppSizes.xl * 8,
                      maxHeight: context.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: sortContent(
                        context: context,
                        sortASC: sortASC,
                      ),
                    ),
                  ),
                  child: IconWithLabelButton(
                    icon: Icons.sort_rounded,
                    active: sortActive.value,
                    text: strings.value.sort,
                    onTap: () {
                      sortActive.value = !sortActive.value;
                      _sortPopoverController.toggle();
                    },
                  ),
                ),
              ),
              // PerPage TextField
              SizedBox(
                width: _expandPerPage.value
                    ? customExpandPerPage ?? AppSizes.xl * 8
                    : AppSizes.xl * 3,
                child: PerPageInput(
                  expandPerPage: _expandPerPage,
                  perPageController: _perPageController,
                  perPage: int.tryParse(_perPageController.text)!,
                  load: () => _perPageController.text != lastPerPage.toString()
                      ? _loadAlerts()
                      : null,
                ),
              ),
            ],
          ),
          //right refresh button
          SizedBox(
            width: AppSizes.xl * 5,
            child: IconWithLabelButton(
              icon: Icons.refresh_rounded,
              onTap: _loadAlerts,
              text: strings.value.refresh,
            ),
          ),
        ],
      ),
    );
  }

  Obx sortContent({
    required BuildContext context,
    required RxBool sortASC,
  }) {
    void setSorter(String s, bool selected) {
      if (_sortASC.value) {
        for (var sorter in _sortersASC.entries) {
          if (sorter.key.toLowerCase() == s.toLowerCase()) {
            _sortersASC[s] = Sorter(
                isSelected: selected,
                orderingValue: sorter.value.orderingValue);
            _loadAlerts();
          } else {
            _sortersASC[sorter.key] = Sorter(
                isSelected: false, orderingValue: sorter.value.orderingValue);
          }
        }
      } else {
        for (var sorter in _sortersDESC.entries) {
          if (sorter.key.toLowerCase() == s.toLowerCase()) {
            _sortersDESC[s] = Sorter(
                isSelected: selected,
                orderingValue: sorter.value.orderingValue);
            _loadAlerts();
          } else {
            _sortersDESC[sorter.key] = Sorter(
                isSelected: false, orderingValue: sorter.value.orderingValue);
          }
        }
      }
    }

    _switchSorters({
      required RxBool sortASC,
      required RxMap<String, Sorter> sortersASC,
      required RxMap<String, Sorter> sortersDESC,
    }) {
      if (sortASC.value) {
        for (var s in _sortersASC.entries) {
          if (s.value.isSelected) {
            sortersDESC[s.key] = Sorter(
                isSelected: true,
                orderingValue: sortersDESC[s.key]!.orderingValue);
            sortersASC[s.key] =
                Sorter(isSelected: false, orderingValue: s.value.orderingValue);
          }
        }
      } else {
        for (var s in _sortersDESC.entries) {
          if (s.value.isSelected) {
            sortersASC[s.key] = Sorter(
                isSelected: true,
                orderingValue: sortersASC[s.key]!.orderingValue);
            sortersDESC[s.key] =
                Sorter(isSelected: false, orderingValue: s.value.orderingValue);
          }
        }
      }
    }

    bool _checkIfLoadIsNeeded({
      required RxMap<String, Sorter> sortersASC,
      required RxMap<String, Sorter> sortersDESC,
    }) {
      final sortASCActive =
          _sortersASC.entries.where((e) => e.value.isSelected).firstOrNull?.key;
      final sortDescActive = _sortersDESC.entries
          .where((e) => e.value.isSelected)
          .firstOrNull
          ?.key;
      if (sortASCActive == null && sortDescActive == null) {
        return false;
      }
      return true;
    }

    final strings = getTranslations(context).obs;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(strings.value.sort,
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(
            height: AppSizes.sm,
          ),
          Text(strings.value.sortAlerts,
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            height: AppSizes.sm,
          ),
          Divider(),
          SizedBox(
            height: AppSizes.md,
          ),
          Text("${strings.value.order} :",
              style: Theme.of(context).textTheme.bodyMedium),
          ShadSelect(
            initialValue:
                sortASC.value ? strings.value.asc : strings.value.desc,
            options: [
              ShadOption(
                  value: strings.value.asc,
                  child: Text(strings.value.asc.toUpperCase())),
              ShadOption(
                  value: strings.value.desc,
                  child: Text(strings.value.desc.toUpperCase())),
            ],
            selectedOptionBuilder: (context, value) => Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onChanged: (value) {
              bool doLoad = _checkIfLoadIsNeeded(
                sortersASC: _sortersASC,
                sortersDESC: _sortersDESC,
              );
              _switchSorters(
                sortASC: sortASC,
                sortersASC: _sortersASC,
                sortersDESC: _sortersDESC,
              );
              sortASC.value = value == strings.value.asc;
              if (doLoad) {
                _loadAlerts();
              }
            },
          ),
          SizedBox(
            height: AppSizes.sm,
          ),
          Text("${strings.value.sortBy} :",
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(
            height: AppSizes.sm,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _sortersASC.keys
                .map(
                  (sorter) => ShadSwitch(
                    uncheckedTrackColor:
                        Theme.of(context).colorScheme.surfaceDim,
                    checkedTrackColor: Theme.of(context).colorScheme.primary,
                    value: (sortASC.value
                        ? _sortersASC[sorter]!.isSelected
                        : _sortersDESC[sorter]!.isSelected),
                    label: Text(
                      sorter.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onChanged: (value) => setSorter(sorter, value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Column filterContent(
      BuildContext context,
      TextEditingController tagFilterController,
      TextEditingController activationStateFilterController) {
    final strings = getTranslations(context).obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(strings.value.filters,
            style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        Text(strings.value.filterAlerts,
            style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(
          height: AppSizes.sm,
        ),
        Divider(),
        SizedBox(
          height: AppSizes.md,
        ),
        Text(strings.value.filterByMonitoredValueTag,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<String>(
          hintText: strings.value.filterByInterval,
          label: Text(strings.value.tag),
          controller: tagFilterController,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: monitorValueTagFilter,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          onSelected: (value) {
            // filter by monitored value tag
            if (monitorValueTagFilter == value) {
              tagFilterController.clear();
              monitorValueTagFilter = null;
              page = 1;
              _loadAlerts();
              return;
            }
            monitorValueTagFilter = value;
            page = 1;
            _loadAlerts();
          },
          dropdownMenuEntries: [
            for (String tag in _allMonitorValueTags)
              DropdownMenuEntry(
                value: tag,
                label: tag,
              ),
          ],
        ),
        Text(strings.value.filterByActivationState,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<bool>(
          hintText: strings.value.selectActivationState,
          label: Text(strings.value.activationState),
          controller: activationStateFilterController,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: activationStateFilter,
          onSelected: (value) {
            // filter by monitored value tag
            if (activationStateFilter == value) {
              activationStateFilterController.clear();
              activationStateFilter = null;
              _loadAlerts();
              return;
            }
            activationStateFilter = value;
            _loadAlerts();
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: true,
              label: strings.value.active,
            ),
            DropdownMenuEntry(
              value: false,
              label: strings.value.inactive,
            ),
          ],
        ),
      ],
    );
  }

  _topPageActionsSmallScreen() {
    final strings = getTranslations(context).obs;
    return Column(
      children: [
        //right refresh button
        IconWithLabelButton(
          icon: Icons.refresh_rounded,
          onTap: _loadAlerts,
          text: strings.value.refresh,
        ),

        SizedBox(
          height: AppSizes.sm,
        ),
        PerPageInput(
          expandPerPage: _expandPerPage,
          perPageController: _perPageController,
          load: () => _perPageController.text != lastPerPage.toString()
              ? _loadAlerts()
              : null,
        ),
        SizedBox(
          height: AppSizes.lg,
        ),
        DividerWithText(text: strings.value.filter),
        filterContent(
            context, _tagFilterController, _activationStateFilterController),
        SizedBox(
          height: AppSizes.xl,
        ),
        DividerWithText(text: strings.value.sort),
        sortContent(
          context: context,
          sortASC: _sortASC,
        ),
      ],
    );
  }
}
